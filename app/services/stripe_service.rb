class StripeService
  require 'stripe'
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"
  Stripe.api_key = 'sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP' if Rails.env.production?
  
  def self.create_customer(name, email)
    response = Stripe::Customer.create(
      {
        name: name,
        email: email
      })
    return response
  end

  def self.update_default_card_at_stripe(user,card_id)
    @current_user = User.find_by_id(user)
    Stripe::Customer.update(
      @current_user.stripe_customer_id,
      {invoice_settings: {default_payment_method: card_id}},
      )
  end

  def self.create_card(customer_id,token)
    card = Stripe::Customer.create_source(customer_id, { source: token })
    return card
  end

end
