class StripeChargeService
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"

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