class Api::V1::StripeConnectsController < Api::V1::ApiController
  before_action :authorize_request

  def refresh_stripe_account_link
    @stripe_link = StripeConnectAccountService.new.create_stripe_account_link(@current_user)
  end

  def user_stripe_connect_account
    stripe_connect_account = @current_user.stripe_connect_account
    if stripe_connect_account.present?
      @account_details = StripeConnectAccount.new.retrieve_stripe_connect_account_against_given_user(stripe_connect_account.account_id)
    else
      @account_details = StripeConnectAccountService.new.create_connect_customer_account(@current_user.email)
    end
  end
  
end