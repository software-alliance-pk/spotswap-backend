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

      email = @current_user.email
      payout_response = PayPalPayOutsService.new.create_payout(email)
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

end