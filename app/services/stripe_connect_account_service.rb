class StripeConnectAccountService
  require 'stripe'
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"
  Stripe.api_key = 'sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP' if Rails.env.production?

  def create_connect_customer_account(current_user, url)
    begin
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

        # https://stripe.com/docs/api/accounts/create?lang=ruby
        # Model name StripeConnectAccount
        #response[:id]  Account id
        # response[:email] Account created email
        #response[:type] Account type
        # response[:external_accounts][:url] External account links
        # response[:login_links][:url]  Login Links

        StripeConnectAccount.create(account_id: account.id, account_country: account.country, account_type: account.type, user_id: current_user.id)

        link = Stripe::AccountLink.create(
          {
            account: current_user.stripe_connect_id,
            refresh_url: url,
            return_url: "https://textng.page.link/qL6j",
            type: "account_onboarding",
          },
        )
        return account_details = { user: current_user, link: link.url }
      end

    rescue Exception => e
      return errors = { error: e.message }
    end
  end

  def create_stripe_account_link(user)
    #https://stripe.com/docs/api/account_links/create
    begin
      response = Stripe::AccountLink.create(
      {
        account: user.stripe_connect_account.account_id,
        refresh_url: refresh_stripe_account_link,
        return_url: '',
        type: 'account_onboarding',
      },
      )
    return response

    rescue Exception => e
      return errors = { error: e.message }
    end
  end

  def retrieve_stripe_connect_account_against_given_user(account_id)
    begin
      response = Stripe::Account.retrieve(account_id)
      #https://stripe.com/docs/api/accounts/retrieve?lang=ruby
      #code here
    rescue Exception => e
      return errors = { error: e.message }
    end
  end

  def delete_stripe_connect_account_against_given_user(account_id)
    begin
      Stripe::Account.delete(account_id)
      #coder here
      #https://stripe.com/docs/api/accounts/delete?lang=ruby
    rescue Exception => e
      return errors = { error: e.message }
    end
  end

  def create_login_link_of_stripe_connect_account(account_id)
      #https://stripe.com/docs/api/account/login_link?lang=ruby
      begin

        Stripe::Account.create_login_link(
        'acct_1Lyz13DGKaWpwN7t',
        )

      #{
      # "object": "login_link",
      # "created": 1667224358,
      # "url": "https://connect.stripe.com/express/PBRTAPCCkWvo",
      # "id": "lael_MiPEyuaZaKhLSS"
      #}
    rescue Exception => e
      return error = { error: e.message }
    end
  end


end