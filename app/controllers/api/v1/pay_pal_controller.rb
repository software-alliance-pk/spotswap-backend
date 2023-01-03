class Api::V1::PayPalController < Api::V1::ApiController
  before_action :authorize_request

  def create_paypal_customer_account
    begin
      paypal_account = @current_user.paypal_partner_account
      if paypal_account.present?
        @account_details = PayPalConnectAccountService.new.retrevie_paypal_customer_account(@current_user)
      else
        @account_details = PayPalConnectAccountService.new.create_paypal_customer_account(@current_user)
      end
      render json: @account_details

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end
  
  def transfer_amount
    begin
      response = PayPalPaymentService.new.transfer_amount(params["account_id"], params["payment_id"], params[:token])
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payment
    begin
      response1 = PayPalGetUserInformationService.new.fetch_user_information(params[:token])
      response = PayPalPaymentService.new.create_payment(@current_user, params[:token])
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def create_payout
    begin
      response = PayPalPayOutsService.new.create_payout
      render json: response
    rescue Exception => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end