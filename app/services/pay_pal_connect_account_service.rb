class PayPalConnectAccountService < BaseService

  def initialize
    super
  end


  def retrevie_paypal_customer_account(account_id = "YjlhZjA2ZDktYTI5Mi00NGM4LThkYTYtMzcyMDFiMTAxOWQyY0hweVowSVFRMVRpR1BldlM3YSs4WUFIdDBwdTBXZE84MllEMEhlcXBUOD12Mg==")
    uri = URI.parse("https://api.sandbox.paypal.com/v2/customer/partner-referrals/#{account_id}")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    return result = JSON.parse(response.body)  if response.code  == "200"
  end

  def create_connect_customer_account(current_user = 1)
    uri = URI.parse("https://api-m.sandbox.paypal.com/v2/customer/partner-referrals")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@token}"
    request.body = JSON.dump({
                               "tracking_id" => "PAYPAL_CUSTOMER_#{current_user}",
                               "operations" => [
                                 {
                                   "operation" => "API_INTEGRATION",
                                   "api_integration_preference" => {
                                     "rest_api_integration" => {
                                       "integration_method" => "PAYPAL",
                                       "integration_type" => "THIRD_PARTY",
                                       "third_party_details" => {
                                         "features" => ["PAYMENT", "REFUND","PARTNER_FEE"]
                                       }
                                     }
                                   }
                                 }
                               ],
                               "products" => ["EXPRESS_CHECKOUT","REFUND","ACCOUNT_BALANCE","DIRECT_PAYMENT","TRANSACTION_DETAILS"],
                               "legal_consents" => [
                                 {
                                   "type" => "SHARE_DATA_CONSENT",
                                   "granted" => true
                                 }
                               ],
                               "partner_config_override" => {
                                 "return_url" => "https://testenterprises.com/merchantonboarded",
                                 "return_url_description" => "the url to return the merchant after the paypal onboarding process.",
                                 "action_renewal_url" => "https://testenterprises.com/renew-exprired-url",
                                 "show_add_credit_card" => true
                               }
                             })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    debugger
    return result = JSON.parse(response.body)  if response.code  == "200"
  end
end