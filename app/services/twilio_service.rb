class TwilioService

  def initialize(phone_number, otp )
    @phone_number = phone_number
    @twilio_sender_number = ENV['TWILIO_PHONE_NUMBER']
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def send_otp
    begin
      response = @client.messages.create(
       from: @twilio_sender_number,
       to: @phone_number,
       body: "Spot Swap verification code is #{@otp}."
     )
      return true
    rescue
      return false
    end
  end

end
