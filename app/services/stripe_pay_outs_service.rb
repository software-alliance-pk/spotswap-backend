class StripePayOutsService
  Stripe.api_key = ENV['STRIPE_API_KEY']

  def create_payout
    begin
      Stripe::Payout.create({
        amount: 1100,
        currency: 'usd',
      })
    rescue Stripe::InvalidRequestError => e
      # Handle specific Stripe error
      puts "Stripe error: #{e.message}"
    rescue => e
      # Handle generic exception
      puts "Error: #{e.message}"
    end
  end

  def retrieve_payout(payout_id)
    begin
      Stripe::Payout.retrieve(payout_id)
    rescue Stripe::InvalidRequestError => e
      # Handle specific Stripe error
      puts "Stripe error: #{e.message}"
    rescue => e
      # Handle generic exception
      puts "Error: #{e.message}"
    end
  end

  def cancel_payout(payout_id)
    begin
      Stripe::Payout.cancel(payout_id)
    rescue Stripe::InvalidRequestError => e
      # Handle specific Stripe error
      puts "Stripe error: #{e.message}"
    rescue => e
      # Handle generic exception
      puts "Error: #{e.message}"
    end
  end
end




# class StripePayOutsService
#   Stripe.api_key = ENV['STRIPE_API_KEY']
#   Stripe.api_key = ENV['STRIPE_API_KEY'] if Rails.env.production?

#   #FOR external_banks
#   def create_payout
#     begin
#     Stripe::Payout.create({
#                             amount: 1100,
#                             currency: 'usd',
#                           })
#     rescue Exception => e

#     end
#   end

#   def retrieve_payout
#     Stripe::Payout.retrieve(
#       'po_1Lz4uS2eZvKYlo2CtyZWgWD5',
#       )
#   end

#   def cancel_payout
#     Stripe::Payout.cancel(
#       'po_1Lz4uS2eZvKYlo2CtyZWgWD5',
#       )
#   end


# end