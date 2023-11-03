class StripeTransferService
  require 'stripe'
  Stripe.api_key = ENV['STRIPE_API_KEY']
  Stripe.api_key = ENV['STRIPE_API_KEY'] if Rails.env.production?
  
  def transfer_amount_of_top_up_to_customer_connect_account(amount, account_id)
    response = Stripe::Transfer.create({
      amount: amount,
      currency: 'usd',
      destination: account_id
    })
    return response
  end
end