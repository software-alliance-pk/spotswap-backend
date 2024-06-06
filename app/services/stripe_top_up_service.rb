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
    rescue Stripe::StripeError => e
      # Handle error
      raise e
    end
  end

  def create_payment_intent(amount)
    begin
      intent = Stripe::PaymentIntent.create({
        amount: amount,
        currency: 'usd',
        # payment_method_types: ['card'],
      })
      { client_secret: intent.client_secret }
    rescue Stripe::StripeError => e
      # Handle error
      raise e
    end
  end

  def retrieve_top_up_info(topup_id)
    begin
      Stripe::Topup.retrieve(topup_id)
    rescue Stripe::StripeError => e
      # Handle error
      raise e
    end
  end

  def cancel_top_up(topup_id)
    begin
      Stripe::Topup.cancel(topup_id)
    rescue Stripe::StripeError => e
      # Handle error
      raise e
    end
  end

  def update_wallet(user, amount)
    # Implement logic to update user's wallet balance
    wallet_new_amount = @current_user.wallet.amount + amount.to_i
    @current_user.wallet.update(amount: wallet_new_amount)
  end
end
