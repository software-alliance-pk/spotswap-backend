class StripeTransferService

  def transfer_amount_of_top_up_to_customer_connect_account
    transfer = Stripe::Transfer.create({
                                         amount: 1900,
                                         currency: 'usd',
                                         destination: 'acct_1M40mdRczK8IPPW2'})
    #destination is the customer account id
  end
end