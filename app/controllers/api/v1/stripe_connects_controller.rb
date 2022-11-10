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
      @account_details = StripeConnectAccountService.new.connect(@current_user)
    end
  end

  def connect
    account = Stripe::Account.create({
      type: "express",
      email: @current_user.email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true },
      },
      business_type: "individual",
      individual: {
        email: @current_user.email,
      },
    })

    @current_user.update(stripe_connect_id: account.id)

    link = Stripe::AccountLink.create(
      {
        account: @current_user.stripe_connect_id,
        refresh_url: connect_api_v1_stripe_connects_url,
        return_url: "https://textng.page.link/qL6j",
        type: "account_onboarding",
      },
    )

    render json: { user: @current_user, link: link.url }
  end

  def login_link
    link = Stripe::Account.create_login_link(@current_user.stripe_connect_id)
    render json: { link: link }
  end
  
end