class Api::V1::WalletsController < Api::V1::ApiController
  before_action :authorize_request

  def charge_amount
    begin
      connection_details =  check_connection_create_before_charge_amount
      return render json: {error: "You have not any Swapper Host Connection."}, status: :unprocessable_entity unless connection_details.present?
      # puts "connection_details while charge amount ==== #{connection_details.inspect}"
      parking_slot = ParkingSlot.find_by_id(connection_details.parking_slot_id)
      # puts "parking_slot   >>>>>>>> #{parking_slot.inspect}"
      total_amount = (parking_slot.amount.to_i + parking_slot.fees.to_i )
          charge_amount_through_wallet(parking_slot.amount.to_i,parking_slot.fees.to_i, connection_details)
          if @is_wallet_out_of_balance
            return render json: {error: "You have Insufficient Balance in your Wallet."}, status: :unprocessable_entity
          else
            notify_host_payment_has_been_sent_from_swapper(connection_details,parking_slot.amount.to_i,parking_slot.fees.to_i )
            connection_details.destroy
          end
    
    rescue Exception => e
      Rails.logger.debug "Error on amout #{e}"
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def add_amount_to_wallet
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      # if @current_user.stripe_connect_account.present?
      #   @connect_account = StripeConnectAccountService.new.retrieve_stripe_connect_account(@current_user.stripe_connect_account.account_id, user_stripe_connect_account_api_v1_stripe_connects_path)
      # else
      #   @connect_account = StripeConnectAccountService.new.create_connect_customer_account(@current_user, user_stripe_connect_account_api_v1_stripe_connects_path)
      # end
      # if @connect_account[:response]&.requirements&.errors.present?
      #   return render json: { error: ["Your Stripe Connect Account data is missing or invalid, Please provide valid data.", @connect_account[:link]] }, status: :unprocessable_entity
      # elsif @connect_account[:response].capabilities.card_payments.eql?("pending") && @connect_account[:response].details_submitted == true
      #   return render json: { error: ["Your Account status is Pending, Please wait, It may takes few minutes.", @connect_account[:link]] }, status: :unprocessable_entity
      # elsif @connect_account[:response]&.requirements&.errors.empty? && (@connect_account[:response].charges_enabled == false || @connect_account[:response].payouts_enabled == false)
      #   return render json: { error: ["Please Complete your Account Details.", @connect_account[:link]] }, status: :unprocessable_entity
      # end

      if params[:referrer_code].present?
        return render json: {error: "You can't use your own Referral Code."}, status: :unprocessable_entity if @current_user.referral_code == params[:referrer_code]
        @referrer = User.find_by(referral_code: params[:referrer_code])
        return render json: {error: "Referral Code is Invalid."}, status: :unprocessable_entity unless @referrer.present?
        @referral_code_record = check_referrer_code_already_in_use(@referrer)
      end
      # @topup_response = StripeTopUpService.new.create_top_up(params[:amount].to_i*100)
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

  def withdraw_amount_from_wallet
    return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
    amount = params[:amount]
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

      if  @current_user.wallet.amount.to_i < amount.to_i
      return render json: {error: "You have Insufficient Balance in your Wallet."}, status: :unprocessable_entity
      end 

      @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account((params[:amount].to_i*100), @current_user.stripe_connect_account.account_id)
      create_payment_history("withdraw", @current_user, '' ,params[:amount].to_i )
      render json: { transfer_response: @transfer_response }, status: :ok
  end 

  def get_wallet_detail
    return render json: {error: "You have not set up your wallet, Please add it first."}, status: :unprocessable_entity unless @current_user.wallet.present?
    @wallet_detail = @current_user.wallet
    @wallet_histories = @current_user.wallet_histories.order(created_at: :desc)
  end

  def get_stripe_connect_balance  
      balance = StripeTransferService.new.connect_balance_check(params[:account_id])
      render json: { balance: balance }, status: :ok
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

  def charge_amount_through_wallet(amount, fees,connection_details)
    swapper_wallet = connection_details.swapper.wallet
    host_wallet = connection_details.host.wallet

    if swapper_wallet && host_wallet
      if swapper_wallet.amount.to_i >= amount.to_i
        # @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account((amount.to_i)*100, connection_details.host.stripe_connect_account.account_id)
        # @transfer_response = StripeTransferService.new.transfer_amount_to_owmer_and_customer((amount.to_i)*100, connection_details.host.stripe_connect_account.account_id )
        # application_fee_amount = (amount.to_i*0.30).to_i
        # remaining_amount = (amount.to_i*0.70).to_i
        puts "amount >>>>> #{amount}"
        # puts "application_fee_amount >>>>> #{application_fee_amount}"
        # puts "remaining_amount >>>>> #{remaining_amount}"
        update_revenue(fees)
        create_payment_history("topup", @current_user, connection_details, (amount+fees))
        create_payment_history("other_payment", connection_details.swapper, connection_details, amount)
        create_payment_history("other_payment", connection_details.host, connection_details, amount)

        connection_details.host.wallet_histories.create(transaction_type: "credited", amount: (amount), title: "Credited")

        wallet_new_amount = host_wallet.amount + amount
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
    elsif  payment_type == "withdraw"
      @wallet_history = user.wallet_histories.create(transaction_type: "debited", top_up_description: "withdraw", amount: amount, title: "Payment")
      wallet_new_amount = @current_user.wallet.amount - amount.to_i
      @current_user.wallet.update(amount: wallet_new_amount)
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

  def notify_host_payment_has_been_sent_from_swapper(connection, amount, fees)
    PushNotificationService.notify_host_payment_has_been_sent_from_swapper(connection, amount.to_i, fees.to_i)
    Notification.create(subject: "Payment Sent by Swapper", body: "Swapper #{connection.swapper.name} has been sent payment of $#{amount.to_i}", notify_by: "Swapper", user_id: connection.host_id, swapper_id: connection.user_id, host_id: connection.host_id)
  end

  def create_wallet_history(amount)
    @current_user.wallet_histories.create(transaction_type: "credited", top_up_description: "bank_transfer", amount: amount, title: "Top Up")
  end

  def update_revenue(amount)
    revenue = Revenue.first_or_initialize # Get the first record or initialize a new one if none exists
    new_amount = revenue.amount. + amount.to_i
    revenue.update(amount: new_amount)
  end
  
end
