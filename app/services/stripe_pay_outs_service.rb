class StripePayOutsService
  Stripe.api_key ="sk_test_51LxA5aDG0Cz60XkmJmG5SqF65UOdl7MC8qoJPwfKZdxw09kRSDUnO649B6UhZuzn05DMILFoy4Ptbz8zDSh1NeBy001ulT1oYP"
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