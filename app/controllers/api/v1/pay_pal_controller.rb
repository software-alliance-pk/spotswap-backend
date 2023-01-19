class Api::V1::PayPalController < Api::V1::ApiController
  before_action :authorize_request

  def create_paypal_customer_account
    begin
      paypal_accounts = @current_user.paypal_partner_accounts
      if paypal_accounts.present?
        paypal_accounts.each do |account|
          if account.email == params[:email]
            @account_details = PayPalConnectAccountService.new.retrevie_paypal_customer_account(@current_user, account)
          end
        end
        @account_details = PayPalConnectAccountService.new.create_paypal_customer_account(@current_user, params[:email])
      else
        @account_details = PayPalConnectAccountService.new.create_paypal_customer_account(@current_user, params[:email])
      end
      render json: @account_details, status: :ok

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  def save_paypal_account_details
    return render json: { error: "Email is missing in params." }, status: :unprocessable_entity unless params[:email].present?
    return render json: { error: "Link is missing in params." }, status: :unprocessable_entity unless params[:link].present?
    return render json: { error: "Paypal Account with this email already exist." }, status: :unprocessable_entity if PaypalPartnerAccount.pluck(:email).include? (params[:email])

    pay_pal_connect_id = params[:link].split("/").last
    account_type = "partner-referrals"
    if @current_user.wallet.present? || @current_user.card_details.present?
      account = @current_user.paypal_partner_accounts.build(account_id: pay_pal_connect_id, account_type: account_type, email: params[:email], payment_type: "paypal")
    else
      account = @current_user.paypal_partner_accounts.build(account_id: pay_pal_connect_id, account_type: account_type, email: params[:email], is_default: true, payment_type: "paypal")
    end
    if account.save
      return render json: { message: "Your Paypal Account has been connected." }, status: :ok
    else
      return render json: { error: "Your Paypal Account could not be connected." }, status: :unprocessable_entity
    end
  end
  
  def transfer_amount
    begin
      payment_response = PayPalPaymentService.new.transfer_amount(params["account_id"], params["payment_id"])
      email = @current_user.swapper_host_connection.host.paypal_partner_accounts.first.email
      payout_response = PayPalPayOutsService.new.create_payout(email)
      update_revenue(1)

      connection_details = @current_user.swapper_host_connection
      create_payment_history(connection_details.swapper, connection_details)
      create_payment_history(connection_details.host, connection_details)
      connection_details.parking_slot.update(user_id: connection_details.swapper.id, availability: false)
      notify_host_payment_has_been_sent_from_swapper(connection_details)
      connection_details.destroy

      return render json: { payment_response: JSON.parse(payment_response), payout_response: JSON.parse(payout_response) }, status: :ok
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payment
    begin
      return render json: { error: "Please make your Paypal Account Default first." }, status: :unprocessable_entity unless @current_user.paypal_partner_accounts.pluck(:is_default).include? true
      response = PayPalPaymentService.new.create_payment(@current_user)
      render json: response, status: :ok
      
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def create_payment_history(user, connection_details)
    @other_history = user.other_histories.create(connection_id: connection_details.id, connection_date_time: connection_details.created_at,
    connection_location: connection_details.parking_slot.address,
    swapper_id: connection_details.swapper.id, host_id: connection_details.host.id, swapper_fee: 10, spotswap_fee: 1, total_fee: 11)
  end

  def notify_host_payment_has_been_sent_from_swapper(connection)
    PushNotificationService.notify_host_payment_has_been_sent_from_swapper(connection, 10)
    Notification.create(subject: "Payment Transfer", body: "Swapper #{connection.swapper.name} has been sent payment of $10.00", notify_by: "Swapper", user_id: connection.host_id, swapper_id: connection.user_id, host_id: connection.host_id)
  end

  def update_revenue(amount)
    admin = Admin.admin.first
    amount = admin&.revenue&.amount + amount
    admin.revenue.update(amount: amount) if amount.present?
  end

end