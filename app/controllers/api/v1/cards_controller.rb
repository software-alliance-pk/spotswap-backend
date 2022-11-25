class Api::V1::CardsController < Api::V1::ApiController
  Stripe.api_key = 'sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP'
  before_action :authorize_request
  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :set_default_card]

  def create_card
    return render json: {error: "Stripe Token parameter is missing "}, status: :unprocessable_entity unless payment_params[:token].present?
    return render json: {error: "Card name parameter is missing"},status: :unprocessable_entity unless payment_params[:name].present?
    return render json: {error: "Country parameter is missing "}, status: :unprocessable_entity unless payment_params[:country].present?

    customer = check_customer_at_stripe
    stripe_token = payment_params[:token]
    card_name =  payment_params[:name]
    card = StripeService.create_card(customer.id, stripe_token)
    return render json: { error: "Card is not created on Stripe" }, status: 422 if card.blank?
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
      render json: { message: "Card deleted successfully." }, status: 200
    else
      render json: { error: "Such card does not exist." }, status: 200
    end
  end

  def update_card
    if @card&.update(payment_params.except(:token, :id))
      @card
    else
      render_error_messages(@card)
    end
  end

  def set_default_card
    if @card
      @current_user.card_details.update_all(is_default: false) unless @card.is_default
      @card.update(is_default: true)
      SetDefaultCardJob.perform_now(@current_user.id, @card.card_id)
    end
  end

  def get_default_card
    @card = @current_user.card_details.where(is_default: true).take
    if @card.present?
      @card
    else
      render json: { error: "User has no default card." }, status: :unprocessable_entity
    end
  end

  private

  def find_card
    return render json: {error: "Payment id parameter is missing."},status: :unprocessable_entity unless payment_params[:id].present?
    @card = CardDetail.find_by(id: payment_params[:id])
    if @card.present?
      @card
    else
      render json: { error: "No such card exist." }, status: :unprocessable_entity
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
      exp_year: card.exp_year, last_digit: card.last4,
      brand: card.brand, country: payment_params[:country],
      fingerprint: card.fingerprint, name: payment_params[:name],
      address: payment_params[:address]
    )
  end

  def payment_params
    params.permit(:token, :name, :id, :address, :country)
  end

end