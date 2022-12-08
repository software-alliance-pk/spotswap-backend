class StripeService
  require 'stripe'
  Stripe.api_key ="sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3"
  Stripe.api_key = 'sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3' if Rails.env.production?
  
  def self.create_customer(name, email)
    response = Stripe::Customer.create(
      {
        name: name,
        email: email
      })
    return response
  end

  def self.update_default_card_at_stripe(user, card_id)
    return Stripe::Customer.update(
      user.stripe_customer_id,
      {invoice_settings: {default_payment_method: card_id}},
      )
  end

  def self.create_card(customer_id, token)
    card = Stripe::Customer.create_source(customer_id, { source: token })
    return card
  end

  def self.destroy_card(customer_id, card_id)
    return Stripe::Customer.delete_source(
      customer_id,
      card_id,
    )
  end

end
