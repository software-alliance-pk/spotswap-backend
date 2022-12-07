class StripeTransferService
  require 'stripe'
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"
  Stripe.api_key = 'sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP' if Rails.env.production?
  
  def transfer_amount_of_top_up_to_customer_connect_account(amount, account_id)
    response = Stripe::Transfer.create({
      amount: amount,
      currency: 'usd',
      destination: account_id,
    })
    return response
  end
end