class StripeTopUpService
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def create_top_up(amount)
    begin
      Stripe::Topup.create(
        {
          amount: amount,
          currency: 'usd',
          description: 'Top-up',
          statement_descriptor: 'Weekly top-up',
        }
      )
    end
  end

  def retrieve_top_up_info(topup_id)
    begin
      Stripe::Topup.retrieve(topup_id)
    end
  end

  def cancel_top_up(topup_id)
    begin
      Stripe::Topup.cancel(topup_id)
    end
  end
end