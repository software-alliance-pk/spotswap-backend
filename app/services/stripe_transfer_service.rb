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


  def transfer_amount_to_owmer_and_customer(amount, account_id)
    application_fee_amount = (amount * 0.30).to_i
    remaining_amount = (amount * 0.70).to_i
    paymentIntent = Stripe::PaymentIntent.create({
    amount: remaining_amount,
    currency: 'usd',
    payment_method:'pm_card_visa',
    confirm:true, 
    # customer: customer['id'],
    # In the latest version of the API, specifying the `automatic_payment_methods` parameter
    # is optional because Stripe enables its functionality by default.
    automatic_payment_methods: {
      enabled: true,
      allow_redirects: 'never'
    },
    application_fee_amount: application_fee_amount,
    transfer_data: {
      destination: account_id,
    },
  })
    paymentIntent

  end

  def connect_balance_check(account_id)
    balance = Stripe::Balance.retrieve({stripe_account: account_id})
    return balance
  end 
end