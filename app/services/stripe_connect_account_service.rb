class StripeConnectAccountService
  require 'stripe'
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"
  Stripe.api_key = 'sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP' if Rails.env.production?

  def create_connect_customer_account(current_user)
    begin
      response = Stripe::Account.create({
                               type: 'express', #account_type
                               country: 'US' , #country
                               email: current_user.email, #email
                               capabilities: {
                                 card_payments: {requested: true},
                                 transfers: {requested: true},
                               },
                               business_type: 'individual',
                               individual: {
                                 email: current_user.email
                               }
                             })
      if response.present?
        #code here .....
        # https://stripe.com/docs/api/accounts/create?lang=ruby
        # Model name StripeConnectAccount
        #response[:id]  Account id
        # response[:email] Account created email
        #response[:type] Account type
        # response[:external_accounts][:url] External account links
        # response[:login_links][:url]  Login Links
        link = Stripe::AccountLink.create(
          {
            account: current_user.stripe_connect_id,
            refresh_url: refresh_stripe_account_link,
            return_url: 'https://textng.page.link/qL6j',
            type: 'account_onboarding',
          },
          )
      end
    rescue Exception => e
      #code here
    end
    render json: { user: @current_user, link: link }
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
    rescue ExceptionWithResponse => e

    end
  end

  def retrieve_stripe_connect_account_against_given_user(account_id)
    debugger
    begin
      response = Stripe::Account.retrieve('acct_1Lyz13DGKaWpwN7t')
      #https://stripe.com/docs/api/accounts/retrieve?lang=ruby
      #code here
    rescue Exception => e
      #code here
    end
  end

  def delete_stripe_connect_account_against_given_user(account_id)
    begin
      Stripe::Account.delete('acct_1032D82eZvKYlo2C')
      #coder here
      #https://stripe.com/docs/api/accounts/delete?lang=ruby
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

    end
  end


end