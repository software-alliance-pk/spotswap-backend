class Api::V1::PayPalController < Api::V1::ApiController
  before_action :authorize_request

  def create_paypal_customer_account
    begin
      paypal_account = @current_user.paypal_partner_account
      if paypal_account.present?
        @account_details = PayPalConnectAccountService.new.retrevie_paypal_customer_account(@current_user)
      else
        @account_details = PayPalConnectAccountService.new.create_paypal_customer_account(@current_user, params[:email])
      end
      render json: @account_details

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end
  
  def transfer_amount
    begin
      response = PayPalPaymentService.new.transfer_amount(params["account_id"], params["payment_id"])
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payment
    begin
      if @current_user.paypal_partner_account.present?
        email = @current_user.paypal_partner_account.email
      end
      response = PayPalPaymentService.new.create_payment(@current_user, email)
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payout
    begin
      if @current_user.paypal_partner_account.present?
        email = @current_user.paypal_partner_account.email
      end
      response = PayPalPayOutsService.new.create_payout(email)
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end