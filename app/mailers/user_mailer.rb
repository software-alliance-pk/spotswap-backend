class UserMailer < ApplicationMailer
  def send_email(user, otp)
    @user = user
    @otp = otp
    mail(to: user.email, subject: "SpotSwap OTP")
  end
end
