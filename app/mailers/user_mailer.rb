class UserMailer < ApplicationMailer
  def send_email(user, otp)
    @user = user
    @otp = otp
    mail(to: "abdullah.hafeez515515@gmail.com", subject: "SpotSwap OTP")
  end
end
