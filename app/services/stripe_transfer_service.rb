class StripeTransferService
  require 'stripe'
  Stripe.api_key ="sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3"
  Stripe.api_key = 'sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3' if Rails.env.production?
  
  def transfer_amount_of_top_up_to_customer_connect_account(amount, account_id)
    response = Stripe::Transfer.create({
      amount: amount,
      currency: 'usd',
      destination: account_id
    })
    return response
  end
end