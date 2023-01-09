class StripeChargeService
  Stripe.api_key ="sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3"

  def charge_amount_from_customer(amount, account_id)
    response = Stripe::Charge.create({
      amount: amount,
      currency: 'usd',
      source: account_id,
      description: 'My First Test Charge (created for API docs at https://www.stripe.com/docs/api)',
    })
    return response
  end
end