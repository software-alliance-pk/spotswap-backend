class StripeChargeService
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"

  def charge_amount_from_customer(amount,source,description)
    begin
    Stripe::Charge.create({
                            amount: 2000,
                            currency: 'usd',
                            source: 'tok_visa',
                            description: 'My First Test Charge (created for API docs at https://www.stripe.com/docs/api)',
                          })
    rescue  Exception => e

    end
  end
end