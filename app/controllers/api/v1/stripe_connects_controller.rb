class Api::V1::StripeConnectsController < Api::V1::ApiController
  before_action :authorize_request

  def refresh_stripe_account_link
    begin
      @stripe_link = StripeConnectAccountService.new.create_stripe_account_link(@current_user, refresh_stripe_account_link_api_v1_stripe_connects_url)
      render json: @stripe_link

    rescue Exception => e
      render json: { error:  e.message } , status: :unprocessable_entity
    end
  end

  def user_stripe_connect_account
    begin
      stripe_connect_account = @current_user.stripe_connect_account
      if stripe_connect_account.present?
        @account_details = StripeConnectAccountService.new.retrieve_stripe_connect_account_against_given_user(stripe_connect_account.account_id)
      else
        @account_details = StripeConnectAccountService.new.create_connect_customer_account(@current_user, refresh_stripe_account_link_api_v1_stripe_connects_url)
      end
      render json: @account_details

    rescue Exception => e
      render json: { error:  e.message } , status: :unprocessable_entity
    end
  end
  
end