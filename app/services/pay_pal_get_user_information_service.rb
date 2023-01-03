
class PayPalGetUserInformationService < BaseService
  require 'net/http'
  require 'uri'

  def fetch_user_information(token)
    debugger
    uri = URI.parse("https://api-m.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{token}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    return response.body
    
  end

end