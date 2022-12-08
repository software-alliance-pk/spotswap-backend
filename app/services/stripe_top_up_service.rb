class StripeTopUpService
  Stripe.api_key ="sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3"
  Stripe.api_key = ENV['STRIPE_API_KEY'] if Rails.env.production?

  def create_top_up(amount)
    return Stripe::Topup.create(
      {
        amount: amount,
        currency: 'usd',
        description: 'Top-up for week of May 31',
        statement_descriptor: 'Weekly top-up',
      },
      )
  end

  def retrieve_top_up_info
    #https://stripe.com/docs/api/topups/retrieve
    begin
    Stripe::Topup.retrieve('tu_1Lz4qz2eZvKYlo2CnlLtJ2B3')
    rescue Exception => e
    end
  end

  def cancel_top_up
    #https://stripe.com/docs/api/topups/cancel
    begin
    Stripe::Topup.cancel(
      'tu_1Lz4qz2eZvKYlo2CnlLtJ2B3',
      )
    rescue Exception => e
    end
  end

end