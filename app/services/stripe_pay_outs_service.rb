class StripePayOutsService
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def create_payout
    begin
      Stripe::Payout.create({
        amount: 1100,
        currency: 'usd',
      })
    rescue Exception => e

    end
  end

  def retrieve_payout(payout_id)
    begin
      Stripe::Payout.retrieve(payout_id)
    end
  end

  def cancel_payout(payout_id)
    begin
      Stripe::Payout.cancel(payout_id)
    end
  end
end