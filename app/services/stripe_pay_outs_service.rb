class StripePayOutsService
  Stripe.api_key ="sk_test_51MCjGDF5sdpBo10rWKvpkwEhZJbh48Ag1IFb9mFDt7JROqylvQX1M5z1cnP3toNkOgYwGNSAXeYziixrF5nhTIPW00JCq17CG3"
  Stripe.api_key = ENV['STRIPE_API_KEY'] if Rails.env.production?

  #FOR external_banks
  def create_payout
    begin
    Stripe::Payout.create({
                            amount: 1100,
                            currency: 'usd',
                          })
    rescue Exception => e

    end
  end

  def retrieve_payout
    Stripe::Payout.retrieve(
      'po_1Lz4uS2eZvKYlo2CtyZWgWD5',
      )
  end

  def cancel_payout
    Stripe::Payout.cancel(
      'po_1Lz4uS2eZvKYlo2CtyZWgWD5',
      )
  end


end