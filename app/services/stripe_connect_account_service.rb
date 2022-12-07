class StripeConnectAccountService
  require 'stripe'
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"
  Stripe.api_key = 'sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP' if Rails.env.production?

  # https://stripe.com/docs/api/accounts/create?lang=ruby
  def create_connect_customer_account(current_user, refresh_url)
    account = Stripe::Account.create({
      type: "express",
      email: current_user.email,
      country: 'US' ,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true },
      },
      business_type: "individual",
      individual: {
        email: current_user.email,
      },
    })

    if account.present?
      current_user.update(stripe_connect_id: account.id)
      StripeConnectAccount.create(account_id: account.id, account_country: account.country, account_type: account.type, user_id: current_user.id)
      link = Stripe::AccountLink.create(
        {
          account: current_user.stripe_connect_id,
          refresh_url: "http://52.55.254.156"+refresh_url,
          return_url: "https://spotswap.page.link/RtQw",
          type: "account_onboarding",
        },
      )
      return account_details = {link: link.url }
    end
  end

  def retrieve_stripe_connect_account(account_id, refresh_url)
    response = Stripe::Account.retrieve(account_id)
    link = Stripe::AccountLink.create(
      {
        account: account_id,
        refresh_url: "http://52.55.254.156"+refresh_url,
        return_url: "https://spotswap.page.link/RtQw",
        type: "account_onboarding",
      },
    )
    return account_details = {link: link.url }
  end

  def create_login_link_of_stripe_connect_account(account_id)
    link = Stripe::Account.create_login_link(account_id)
  end

end