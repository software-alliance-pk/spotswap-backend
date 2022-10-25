class Api::V1::CardsController < Api::V1::ApiController
  Stripe.api_key = 'sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h'
  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :set_default_card]

  def create
    customer = check_customer_at_stripe
    stripe_token = payment_params[:token]
    card_name =  payment_params[:name]
    card = StripeService.create_card(customer.id,stripe_token)
    return render json: { message: "Card is not created on Stripe" }, status: 422 if card.blank?
    @card = create_user_payment_card(card)
    make_first_card_as_default
    if @card
      @card
    else
      render_error_messages(@card)
    end
  end

  def get_card
    if @card.present?
      @card
    end
  end

  def get_all_cards
    @cards = @current_user.card_details
    if @cards.present?
      @cards
    end
  end

  def destroy_card
    if @card.present?
      @card.destroy
      user_cards_info = @current_user.card_details
      find_first_card = user_cards_info&.first unless user_cards_info.pluck(:is_default).include?(true)
      if find_first_card
        find_first_card.update(is_default: true)
      end
      render json: { message: "Card deleted successfully!" }, status: 200
    else
      render json: { message: "Such card does not exists" }, status: 200
    end
  end

  def update_card
    if @card&.update(name: payment_params[:name], country: payment_params[:country])
      @card
    else
      render_error_messages(@card)
    end
  end

  def set_default_card
    if @card
      @current_user.card_details.update_all(is_default: false) unless @card.is_default
      @card.update(is_default: true)
      SetDefaultCardJob.perform_now(@current_user.id,@card.card_id)
    end
  end

  def get_default_card
    @card = @current_user.card_details&.is_default.take
    if @card
      @card
    else
      render json: { message: "user has no card" }
    end
  end

  private
  def find_card
    if payment_params[:id].present?
      @card = CardDetail.find_by(id: payment_params[:id])
      if @card
        @card
      else
        render json: { message: "No such card exists" }, status: :ok
      end
    else
      render json: { message: "Payment id parameter is missing" }, status: :ok
    end
  end

  def check_customer_at_stripe
    if @current_user.stripe_customer_id.present?
      customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id) rescue nil
    else
      customer = StripeService.create_customer(payment_params[:name], @current_user.email)
      @current_user.update(stripe_customer_id: customer.id) rescue nil
    end
    return customer
  end

  def make_first_card_as_default
    @current_user.card_details.update(is_default: true) if @current_user.card_details.count < 2
  end

  def create_user_payment_card(card)
    @current_user.card_details.create(
      card_id: card.id, exp_month: card.exp_month,
      exp_year: card.exp_year, last4: card.last_digit,
      brand: card.brand, country: payment_params[:country],
      fingerprint: card.fingerprint, name: payment_params[:name]
    )
  end

  def payment_params
    params.require(:payment).permit(:token, :name, :id, :country)
  end
end