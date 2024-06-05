class Api::V1::StripeConnectsController < Api::V1::ApiController
  before_action :authorize_request

  def user_stripe_connect_account
    begin
      stripe_connect_account = @current_user.stripe_connect_account
      if stripe_connect_account.present?
        @account_details = StripeConnectAccountService.new.retrieve_stripe_connect_account(stripe_connect_account.account_id, user_stripe_connect_account_api_v1_stripe_connects_path)
        wallet = @current_user.wallet
        default_payment = @current_user.default_payment
      else
        @account_details = StripeConnectAccountService.new.create_connect_customer_account(@current_user, user_stripe_connect_account_api_v1_stripe_connects_path)
        if @current_user.paypal_partner_accounts.present? || @current_user.card_details.present?
          wallet = @current_user.build_wallet(amount: 0, payment_type: "wallet")
        else
          wallet = @current_user.build_wallet(amount: 0, payment_type: "wallet", is_default: true)
          default_payment = @current_user.build_default_payment(payment_type: "wallet")
          default_payment.save!
        end
        if wallet.save
          wallet
        end
      end
      render json: {account_details: @account_details, wallet: wallet, default_payment: default_payment}

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  def create_login_link
    begin
      link = StripeConnectAccountService.new.create_login_link_of_stripe_connect_account(@current_user.stripe_connect_id)
      render json: { link: link }

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  def retrieve_connect_account
    begin
      account = StripeConnectAccountService.new.retrieve_stripe_connect_account(@current_user.stripe_connect_id, user_stripe_connect_account_api_v1_stripe_connects_path)
      render json: { account: account }

    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  def create_payment_intent
    amount = params[:amount]
    service = StripeTopUpService.new
    intent = service.create_payment_intent(amount.to_i)

    if intent
      render json: intent
    else
      render json: { error: 'Failed to create payment intent' }, status: :unprocessable_entity
    end
  end

  def update_wallet
    # This action will be called after successful payment
    user = current_user
    amount = params[:amount]
    service = StripeTopUpService.new
    service.update_wallet(user, amount.to_i)
    render json: { message: 'Wallet updated successfully' }
  end
  
end