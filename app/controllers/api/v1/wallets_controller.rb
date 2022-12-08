class Api::V1::WalletsController < Api::V1::ApiController
  before_action :authorize_request

  def charge_amount
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      connection_details =  check_connection_create_before_charge_amount
      return render json: {error: "You have not any Swapper Host Connection."}, status: :unprocessable_entity unless connection_details.present?
      return render json: {error: "User has not any stripe connect account."}, status: :unprocessable_entity unless connection_details.swapper.stripe_connect_account.present?
      @default_payment = @current_user.default_payment
      if @default_payment.present?
        if @default_payment.payment_type == "paypal"
          return render json: {error: "PayPal Payment is not completed yet."}, status: :unprocessable_entity
        elsif @default_payment.payment_type == "credit_card"
          charge_amount_through_credit_card(params[:amount], connection_details)
          create_payment_history("other_payment", connection_details, params[:amount])
        elsif @default_payment.payment_type == "wallet"
          charge_amount_through_wallet(params[:amount], connection_details)
          create_payment_history("topup", connection_details, params[:amount])
        else
          return render json: {error: "Please enter the valid payment type"},status: :unprocessable_entity
        end
      else
        return render json: {error: "Please add Default Payment first."}, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payment_history(payment_type, connection_details, amount)
    if payment_type == "other_payment"
      @other_history = @current_user.other_histories.create(connection_date_time: connection_details.created_at,
      connection_location: connection_details.parking_slot.address,
      swapper_id: connection_details.swapper.id, swapper_fee: amount, spotswap_fee: 1)
    else
      @wallet_history = @current_user.wallet_histories.create(transaction_type: "credited", top_up_description: "spot_swap", amount: amount, title: "Payment")
    end
  end

  def add_amount_to_wallet
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      if @current_user.stripe_connect_account.present?
        @connect_account = StripeConnectAccountService.new.retrieve_stripe_connect_account(@current_user.stripe_connect_account.account_id, user_stripe_connect_account_api_v1_stripe_connects_path)
      else
        @connect_account = StripeConnectAccountService.new.create_connect_customer_account(@current_user, user_stripe_connect_account_api_v1_stripe_connects_path)
      end

      if @connect_account[:response].charges_enabled == false
        return render json: {error: "You have not set up any Stripe Connect Account.", link: @connect_account[:link]}, status: :unprocessable_entity
      end
      if params[:referrer_code].present?
        @referrer = User.find_by(referral_code: params[:referrer_code])
        return render json: {error: "Referral Code is InValid."}, status: :unprocessable_entity unless @referrer.present?
        @referral_code_record = check_referrer_code_already_in_use(@referrer)
      end  
      @topup_response = StripeTopUpService.new.create_top_up(params[:amount])

      @wallet = @current_user.build_wallet(amount: new_amount_needs_to_add_in_wallet(params[:amount]))
      @wallet.wallet_amount = params[:amount]
      if @wallet.save
        @referral_code_record.update(is_top_up_created: true) if params[:referrer_code].present?
        @wallet
      else
        render_error_messages(@wallet)
      end
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def get_wallet_detail
    return render json: {error: "You have not any Wallet, Please add it."}, status: :unprocessable_entity unless @current_user.wallet.present?
    @wallet_detail = @current_user.wallet
    @wallet_histories = @current_user.wallet_histories.order(created_at: :desc)
  end

  private

  def get_wallet_previous_amount
    @current_user.wallet&.amount
  end

  def new_amount_needs_to_add_in_wallet(amount)
    amount = amount.to_f + get_wallet_previous_amount.to_f
  end

  def check_referrer_code_already_in_use(referrer)
    record  = @current_user.user_referral_code_records.find_by(referrer_id: referrer.id)
    record = UserReferralCodeRecord.create(user_id: @current_user.id, user_code: @current_user.referral_code, referrer_code: referrer.referral_code, referrer_id: referrer.id) unless record.present?
    return record
  end

  def check_connection_create_before_charge_amount
    @current_user.swapper_host_connection || @current_user.host_swapper_connection
  end

  def charge_amount_through_wallet(amount, connection_details)
    if connection_details.swapper.wallet.amount.to_i >= amount.to_i
      @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount, connection_details.host.stripe_connect_account.account_id)
    else
      return render json: {error: "You have Insufficient Balance in your Wallet."}, status: :unprocessable_entity
    end
  end

  def charge_amount_through_credit_card(amount, connection_details)
    @charge_response = StripeChargeService.new.charge_amount_from_customer(amount, connection_details.swapper.stripe_connect_account.account_id)
    @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount, connection_details.host.stripe_connect_account.account_id )
  end

  def charge_amount_through_paypal
  end
end