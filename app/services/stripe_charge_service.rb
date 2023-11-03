class StripeChargeService
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def charge_amount_from_customer(amount, customer_id)
    response = Stripe::Charge.create({
      amount: amount,
      currency: 'usd',
      customer: customer_id,
      description: 'My First Test Charge (created for API docs at https://www.stripe.com/docs/api)',
    })
    return response
  end
end