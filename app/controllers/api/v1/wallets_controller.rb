class Api::V1::WalletsController < Api::V1::ApiController
  before_action :authorize_request

  def charge_amount
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      connection_details =  check_connection_create_before_charge_amount
      return render json: {error: "You have not any Swapper Host Connection."}, status: :unprocessable_entity unless connection_details.present?
      # return render json: {error: "User has not any Stripe Connect Account."}, status: :unprocessable_entity unless connection_details.swapper.stripe_connect_account.present?
      # return render json: {error: "Host has not any Stripe Connect Account."}, status: :unprocessable_entity unless connection_details.host.stripe_connect_account.present?

      @default_payment = connection_details.swapper.default_payment
      if @default_payment.present?
        if @default_payment.payment_type == "paypal"
          @paypal_payment_response = PayPalPaymentService.new.create_payment
        elsif @default_payment.payment_type == "credit_card"
          charge_amount_through_credit_card(params[:amount], connection_details)
          create_payment_history("other_payment", connection_details, params[:amount].to_i-1)
          connection_details.parking_slot.update(user_id: connection_details.swapper.id, availability: false)
          notify_host_payment_has_been_sent_from_swapper(connection_details, params[:amount])
          connection_details.destroy
        elsif @default_payment.payment_type == "wallet"
          charge_amount_through_wallet(params[:amount], connection_details)
          notify_host_payment_has_been_sent_from_swapper(connection_details, params[:amount])
          connection_details.destroy
        else
          return render json: {error: "Please enter the valid payment type."},status: :unprocessable_entity
        end
      else
        return render json: {error: "Please add Default Payment first."}, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
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
      if @connect_account[:response]&.requirements&.errors.present?
        return render json: { error: ["Your Stripe Connect Account data is missing or invalid, Please provide valid data.", @connect_account[:link]] }, status: :unprocessable_entity
      elsif @connect_account[:response].capabilities.card_payments.eql?("pending") && @connect_account[:response].details_submitted == true
        return render json: { error: ["Your Account status is Pending, Please wait, It may takes few minutes.", @connect_account[:link]] }, status: :unprocessable_entity
      elsif @connect_account[:response]&.requirements&.errors.empty? && (@connect_account[:response].charges_enabled == false || @connect_account[:response].payouts_enabled == false)
        return render json: { error: ["Please Complete your Account Details.", @connect_account[:link]] }, status: :unprocessable_entity
      end

      if params[:referrer_code].present?
        @referrer = User.find_by(referral_code: params[:referrer_code])
        return render json: {error: "Referral Code is Invalid."}, status: :unprocessable_entity unless @referrer.present?
        @referral_code_record = check_referrer_code_already_in_use(@referrer)
      end
      @topup_response = StripeTopUpService.new.create_top_up(params[:amount].to_i*100)
      if @current_user.paypal_partner_accounts.present? || @current_user.card_details.present?
        @wallet = @current_user.build_wallet(amount: new_amount_needs_to_add_in_wallet(params[:amount]), payment_type: "wallet")
        create_wallet_history(params[:amount])
      else
        @wallet = @current_user.build_wallet(amount: new_amount_needs_to_add_in_wallet(params[:amount]), is_default: true, payment_type: "wallet")
        create_wallet_history(params[:amount])
      end
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
    @current_user.swapper_host_connection
  end

  def charge_amount_through_wallet(amount, connection_details)
    if connection_details.swapper.wallet.amount.to_i >= amount.to_i
      @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account((amount.to_i)*100, connection_details.host.stripe_connect_account.account_id)
      create_payment_history("topup", connection_details, amount)
      connection_details.host.wallet_histories.create(transaction_type: "credited", amount: amount)
      connection_details.parking_slot.update(user_id: connection_details.swapper.id, availability: false)
    else
      return render json: {error: "You have Insufficient Balance in your Wallet."}, status: :unprocessable_entity
    end
  end

  def create_payment_history(payment_type, connection_details, amount)
    if payment_type == "other_payment"
      @other_history = @current_user.other_histories.create(connection_id: connection_details.id, connection_date_time: connection_details.created_at,
      connection_location: connection_details.parking_slot.address,
      swapper_id: connection_details.swapper.id, host_id: connection_details.host.id, swapper_fee: amount, spotswap_fee: 1, total_fee: amount+1)
    else
      @wallet_history = @current_user.wallet_histories.create(transaction_type: "debited", top_up_description: "spot_swap", amount: amount, title: "Payment")
    end
  end

  def charge_amount_through_credit_card(amount, connection_details)
    amount = amount.to_i*100
    @charge_response = StripeChargeService.new.charge_amount_from_customer(amount, connection_details.swapper.stripe_connect_account.account_id)
    @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount, connection_details.host.stripe_connect_account.account_id)
  end

  def charge_amount_through_paypal
  end

  def notify_host_payment_has_been_sent_from_swapper(connection, amount)
    PushNotificationService.notify_host_payment_has_been_sent_from_swapper(connection, amount)
  end

  def create_wallet_history(amount)
    # StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount.to_i, @current_user.stripe_connect_account.account_id)
    @current_user.wallet_histories.create(transaction_type: "credited", top_up_description: "bank_transfer", amount: amount, title: "Top Up")
  end
end