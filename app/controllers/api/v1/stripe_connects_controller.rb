class Api::V1::StripeConnectsController < Api::V1::ApiController
  before_action :authorize_request


  def user_stripe_connect_account
    begin
      stripe_connect_account = @current_user.stripe_connect_account
      if stripe_connect_account.present?
        @account_details = StripeConnectAccountService.new.retrieve_stripe_connect_account(stripe_connect_account.account_id, user_stripe_connect_account_api_v1_stripe_connects_path)
        wallet = @current_user.wallet
      else
        @account_details = StripeConnectAccountService.new.create_connect_customer_account(@current_user, user_stripe_connect_account_api_v1_stripe_connects_path)
        wallet = @current_user.build_wallet(amount: 0)
        if wallet.save
          wallet
        end
      end
      render json: {account_details: @account_details, wallet: wallet}

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
  
end