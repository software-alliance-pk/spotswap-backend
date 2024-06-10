class Api::V1::WalletsController < Api::V1::ApiController
  before_action :authorize_request

  def charge_amount
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      connection_details =  check_connection_create_before_charge_amount
      return render json: {error: "You have not any Swapper Host Connection."}, status: :unprocessable_entity unless connection_details.present?

      @default_payment = connection_details.swapper.default_payment
      if @default_payment.present?
        if @default_payment.payment_type == "paypal"
          
        elsif @default_payment.payment_type == "credit_card"
          charge_amount_through_credit_card(params[:amount], connection_details)
          create_payment_history("other_payment", connection_details.swapper, connection_details, params[:amount].to_i-1)
          create_payment_history("other_payment", connection_details.host, connection_details, params[:amount].to_i-1)
          connection_details.host.wallet_histories.create(transaction_type: "credited", amount: params[:amount].to_i-1, title: "Credited")

          wallet_new_amount = connection_details.host.wallet.amount + params[:amount].to_i-1
          connection_details.host.wallet.update(amount: wallet_new_amount)

          connection_details.parking_slot.update(user_id: connection_details.swapper.id, availability: false)
          notify_host_payment_has_been_sent_from_swapper(connection_details, params[:amount])
          connection_details.destroy
        elsif @default_payment.payment_type == "wallet"
          charge_amount_through_wallet(params[:amount], connection_details)
          if @is_wallet_out_of_balance
            return render json: {error: "You have Insufficient Balance in your Wallet."}, status: :unprocessable_entity
          else
            notify_host_payment_has_been_sent_from_swapper(connection_details, params[:amount])
            connection_details.destroy
          end
        else
          return render json: {error: "Please enter the valid payment type."},status: :unprocessable_entity
        end
      else
        return render json: {error: "Please add Default Payment first."}, status: :unprocessable_entity
      end
    rescue Exception => e
      Rails.logger.debug "Error on amout #{e}"
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
        return render json: {error: "You can't use your own Referral Code."}, status: :unprocessable_entity if @current_user.referral_code == params[:referrer_code]
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
        default_payment = @current_user.build_default_payment(payment_type: "wallet").save
        @wallet
      else
        render_error_messages(@wallet)
      end
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def get_wallet_detail
    return render json: {error: "You have not set up your wallet, Please add it first."}, status: :unprocessable_entity unless @current_user.wallet.present?
    @wallet_detail = @current_user.wallet
    @wallet_histories = @current_user.wallet_histories.order(created_at: :desc)
  end

  def get_stripe_connect_balance
    connection_details =  check_connection_create_before_charge_amount
    swapper_wallet = connection_details.swapper.wallet
    host_wallet = connection_details.host.wallet

    if swapper_wallet.present?
      balance = StripeTransferService.new.connect_balance_check(connection_details.swapper.stripe_connect_account.account_id)
    else
      balance = StripeTransferService.new.connect_balance_check(connection_details.host.stripe_connect_account.account_id)
    end
    render json: { balance: balance, stripe_account: connection_details.host.stripe_connect_account.account_id , connection_details: connection_details }, status: :ok
  end 

  def transfer_to_owner
    amount = params[:amount]
    connection_details =  check_connection_create_before_charge_amount
    swapper_wallet = connection_details.swapper.wallet
    host_wallet = connection_details.host.wallet
    # response = StripeTransferService.new.transfer_amount_to_owmer_and_customer((amount.to_i)*100, connection_details.host.stripe_connect_account.account_id)
    render json: { swapper_wallet:swapper_wallet, host_wallet:host_wallet, connection_details: connection_details }, status: :ok
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
    swapper_wallet = connection_details.swapper.wallet
    host_wallet = connection_details.host.wallet

    if swapper_wallet && host_wallet
      if swapper_wallet.amount.to_i >= amount.to_i
        @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account((amount.to_i)*100, connection_details.host.stripe_connect_account.account_id)
        update_revenue(1)
        create_payment_history("topup", @current_user, connection_details, amount)
        create_payment_history("other_payment", connection_details.swapper, connection_details, amount.to_i-1)
        create_payment_history("other_payment", connection_details.host, connection_details, amount.to_i-1)

        connection_details.host.wallet_histories.create(transaction_type: "credited", amount: (amount.to_i-1), title: "Credited")

        wallet_new_amount = host_wallet.amount + (amount.to_i - 1)
        host_wallet.update(amount: wallet_new_amount)

        connection_details.parking_slot.update(user_id: connection_details.swapper.id, availability: false)
        @is_wallet_out_of_balance = false
      else
        @is_wallet_out_of_balance = true
      end
    else
      @is_wallet_out_of_balance = true
    end
  end

  def create_payment_history(payment_type, user, connection_details, amount)
    if payment_type == "other_payment"
      @other_history = user.other_histories.create(connection_id: connection_details.id, connection_date_time: connection_details.created_at,
      connection_location: connection_details.parking_slot.address,
      swapper_id: connection_details.swapper.id, host_id: connection_details.host.id, swapper_fee: amount, spotswap_fee: 1, total_fee: amount+1)
    else
      @wallet_history = user.wallet_histories.create(transaction_type: "debited", top_up_description: "spot_swap", amount: amount, title: "Payment")
      wallet_new_amount = @current_user.wallet.amount - amount.to_i
      @current_user.wallet.update(amount: wallet_new_amount)
    end
  end

  def charge_amount_through_credit_card(amount, connection_details)
    amount = amount.to_i*100
    @charge_response = StripeChargeService.new.charge_amount_from_customer(amount, connection_details.swapper.stripe_customer_id)
    @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(amount-100, connection_details.host.stripe_connect_account.account_id)
    update_revenue(1)
  end

  def charge_amount_through_paypal
  end

  def notify_host_payment_has_been_sent_from_swapper(connection, amount)
    PushNotificationService.notify_host_payment_has_been_sent_from_swapper(connection, amount.to_i-1)
    Notification.create(subject: "Payment Sent by Swapper", body: "Swapper #{connection.swapper.name} has been sent payment of $11.00", notify_by: "Swapper", user_id: connection.host_id, swapper_id: connection.user_id, host_id: connection.host_id)
  end

  def create_wallet_history(amount)
    @current_user.wallet_histories.create(transaction_type: "credited", top_up_description: "bank_transfer", amount: amount, title: "Top Up")
  end

  def update_revenue(amount)
    revenue = Revenue.first_or_initialize # Get the first record or initialize a new one if none exists
    new_amount = revenue.amount.to_i + amount.to_i
    revenue.update(amount: new_amount)
  end
  
end
