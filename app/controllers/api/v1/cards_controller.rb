class Api::V1::CardsController < Api::V1::ApiController
  Stripe.api_key = 'sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3'
  before_action :authorize_request
  before_action :find_card, only: [:get_card, :destroy_card, :update_card, :set_default_card]

  def create_card
    return render json: {error: "Stripe Token parameter is missing "}, status: :unprocessable_entity unless payment_params[:token].present?
    return render json: {error: "Card name parameter is missing"},status: :unprocessable_entity unless payment_params[:name].present?
    return render json: {error: "Country parameter is missing "}, status: :unprocessable_entity unless payment_params[:country].present?

    customer = check_customer_at_stripe
    stripe_token = payment_params[:token]
    card_name =  payment_params[:name]
    @stripe_card_response = StripeService.create_card(customer.id, stripe_token)
    return render json: { error: "Card is not created on Stripe" }, status: 422 unless @stripe_card_response.present?
    @card = create_user_payment_card(@stripe_card_response)
    # unless @current_user.paypal_partner_account.is_default? && @current_user.wallet.is_default?
    #   make_first_card_as_default(@card)
    # end
    if @card
      @card
      @stripe_card_response
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
    @cards = @current_user.card_details.order(created_at: :asc)
    if @cards.present?
      @cards
    end
    @wallet = @current_user.wallet

    # unless @current_user.paypal_partner_account.present?
    #   if @current_user.wallet.present? && !@current_user.card_details.present?
    #     if @current_user.wallet.is_default?
    #       @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: false).save
    #     else
    #       @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: true).save
    #     end
    #   elsif @current_user.card_details.present? && !@current_user.wallet.present?
    #     if (@current_user.card_details.pluck(:is_default).include? true)
    #       @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: false).save
    #     else
    #       @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: true).save
    #     end
    #   elsif @current_user.card_details.present? && @current_user.wallet.present?
    #     if @current_user.wallet.is_default? || (@current_user.card_details.pluck(:is_default).include? true)
    #       @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: false).save
    #     else
    #       @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: true).save
    #     end
    #   else
    #     @current_user.build_paypal_partner_account(payment_type: "paypal", is_default: true).save
    #   end
    # end

    @paypal_account = @current_user&.paypal_partner_accounts
  end

  def destroy_card
    @card_id = @card.card_id
    if @card.present?
      @card.destroy
      user_cards_info = @current_user.card_details

      if !user_cards_info.present?
        if @current_user.wallet.present?
          @current_user.wallet.update(is_default: true)
        elsif @current_user.paypal_partner_accounts.present?
          @current_user.paypal_partner_accounts.first.update(is_default: true)
        end
      else
        find_first_card = user_cards_info&.first unless user_cards_info.pluck(:is_default).include?(true)
        if find_first_card
          find_first_card.update(is_default: true)
        end
      end
      customer = check_customer_at_stripe
      @stripe_card_response = StripeService.destroy_card(customer.id, @card_id)
    else
      render json: { error: "Such card does not exist." }, status: :unprocessable_entity
    end
  end

  def update_card
    if @card&.update(payment_params.except(:token, :id))
      @card
    else
      render_error_messages(@card)
    end
  end

  def make_payment_default
    return render json: {error: "Payment Type is missing."}, status: :unprocessable_entity unless params[:payment_type].present?
    if params[:payment_type] == "credit_card"
      return render json: {error: "Card Detail Id is missing."}, status: :unprocessable_entity unless params[:card_detail_id].present?
      @card_detail = CardDetail.find_by_id(params[:card_detail_id])
      return render json: {error: "Car Detail with this Id is not present."}, status: :unprocessable_entity unless @card_detail.present?
      return render json: {error: "User has not any Card with this Id."}, status: :unprocessable_entity unless @current_user.card_details.include? @card_detail
      if @card_detail.is_default == true
        @default_payment = DefaultPayment.find_by(card_detail_id: @card_detail.id)
      else
        @default_payment = @current_user.build_default_payment(card_detail_id: params[:card_detail_id], payment_type: params[:payment_type])
        if @default_payment.save
          @current_user.card_details.update(is_default: false)
          @card_detail.update(is_default: true)
          @current_user.paypal_partner_accounts.update(is_default: false) if @current_user.paypal_partner_accounts.present?
          @current_user.wallet.update(is_default: false) if @current_user.wallet.present?
        else
          render_error_messages(@default_payment)
        end
      end
      @card = StripeService.update_default_card_at_stripe(@current_user, CardDetail.find_by(id: @default_payment.card_detail_id).card_id)
    elsif params[:payment_type] == "wallet"
      @default_payment = @current_user.build_default_payment(payment_type: params[:payment_type])
      if @default_payment.save
        @current_user.card_details.update(is_default: false) if @current_user.card_details.present?
        @current_user.paypal_partner_accounts.update(is_default: false) if @current_user.paypal_partner_accounts.present?
        @current_user.wallet.update(payment_type:"wallet", is_default: true) if @current_user.wallet.present?
      else
        render_error_messages(@default_payment)
      end
    elsif params[:payment_type] == "paypal"
      return render json: {error: "Paypal Account Id is missing."}, status: :unprocessable_entity unless params[:paypal_account_id].present?
      @paypal_account = PaypalPartnerAccount.find_by_id(params[:paypal_account_id])
      return render json: {error: "Paypal Account with this Id is not present."}, status: :unprocessable_entity unless @paypal_account.present?
      return render json: {error: "User has not any Paypal Account with this Id."}, status: :unprocessable_entity unless @current_user.paypal_partner_accounts.include? @paypal_account
      if @paypal_account.is_default == true
        @paypal_account = DefaultPayment.find_by(paypal_account_id: @paypal_account.id)
      else
        @default_payment = @current_user.build_default_payment(payment_type: params[:payment_type], paypal_account_id: params[:paypal_account_id])
        if @default_payment.save
          @current_user.card_details.update(is_default: false) if @current_user.card_details.present?
          @current_user.wallet.update(is_default: false) if @current_user.wallet.present?
          @current_user.paypal_partner_accounts.update(is_default: false) if @current_user.paypal_partner_accounts.present?
          @paypal_account.update(payment_type:"paypal", is_default: true)
        else
          render_error_messages(@default_payment)
        end
      end
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

  def make_first_card_as_default(card)
    if @current_user.card_details.count < 2
      @current_user.card_details.update(is_default: true)
      @default_payment = @current_user.build_default_payment(card_detail_id: card.id, payment_type: card.payment_type)
      if @default_payment.save
        CardDetail.find_by(id: card.id).update(is_default: true)
      else
        render_error_messages(@default_payment)
      end
    end
  end

  def create_user_payment_card(card)
    if @current_user.wallet.present? || @current_user.paypal_partner_accounts.present? || ((@current_user.card_details.pluck(:is_default).include? true) if @current_user.card_details.present?)
      @current_user.card_details.create(
      card_id: card.id, exp_month: card.exp_month,
      exp_year: card.exp_year, last_digit: card.last4,
      brand: card.brand, country: payment_params[:country],
      fingerprint: card.fingerprint, name: payment_params[:name],
      address: payment_params[:address], payment_type: payment_params[:payment_type],
      payment_type: "credit_card"
    )
    else
      @current_user.card_details.create(
      card_id: card.id, exp_month: card.exp_month,
      exp_year: card.exp_year, last_digit: card.last4,
      brand: card.brand, country: payment_params[:country],
      fingerprint: card.fingerprint, name: payment_params[:name],
      address: payment_params[:address], payment_type: payment_params[:payment_type],
      is_default: true, payment_type: "credit_card"
    )
    end
    
  end

  def payment_params
    params.permit(:token, :name, :id, :address, :country, :payment_type, :card_detail_id)
  end

end