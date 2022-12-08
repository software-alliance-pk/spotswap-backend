class PayPalPaymentService <  BaseService

  def initialize
    super
  end

  def create_payment(email = "sb-lu2o323466027@personal.example.com", amount = 30.00,spotswap_fee=1.00)
    total_amount = amount + spotswap_fee
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/payments/payment")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "intent" => "sale",
                               "payer" => {
                                 "payment_method" => "paypal"
                               },
                               "transactions" => [
                                 {
                                   "amount" => {
                                     "total" => total_amount,
                                     "currency" => "USD",
                                     "details" => {
                                       "subtotal" => amount,
                                       "tax" => "0.00",
                                       "shipping" => "0.00",
                                       "handling_fee" => spotswap_fee,
                                       "shipping_discount" => "0.00",
                                       "insurance" => "0.00"
                                     }
                                   },
                                   "description" => "The payment transaction description.",
                                   "custom" => email,
                                   "payment_options" => {
                                     "allowed_payment_method" => "INSTANT_FUNDING_SOURCE"
                                   }
                                 }
                               ],
                               "redirect_urls": {
                                 "return_url": "https://spotswap.page.link/RtQw",
                                 "cancel_url": "https://spotswap.page.link/RtQw"
                               }
                             })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def transfer_amount(payment_id = "PAYID-MOJAJMY5TJ46490YG3248534",account_id="NC8AYA37LCYKY")
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/payments/payment/#{payment_id}/execute")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "payer_id" => account_id
                             })

    #payer_id means Destination Account
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end
end