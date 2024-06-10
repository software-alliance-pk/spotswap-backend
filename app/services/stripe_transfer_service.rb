class StripeTransferService
  require 'stripe'
  Stripe.api_key = ENV['STRIPE_API_KEY']
  Stripe.api_key = ENV['STRIPE_API_KEY'] if Rails.env.production?
  
  def transfer_amount_of_top_up_to_customer_connect_account(amount, recipient_account_id)
    application_fee_amount = (amount * 0.30).to_i

    payment_intent = Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'usd',
      payment_method_types: ['card'],
      application_fee_amount: application_fee_amount,
      transfer_data: {
        destination: recipient_account_id
      }
    }, {
      stripe_account: recipient_account_id
    })

    payment_intent
  end

  def connect_balance_check(account_id)
    balance = Stripe::Balance.retrieve({stripe_account: account_id})
    return balance
  end 
end