class Admins::OtpVerificationsController < ApplicationController
 
  def otp_verification
  end
 
  def verify_otp
    @otp = params[:otp][:first_digit]+params[:otp][:second_digit]+params[:otp][:third_digit]+params[:otp][:fourth_digit]+params[:otp][:fifth_digit]+params[:otp][:sixth_digit]
    if  @otp == $otp
      redirect_to edit_admin_password_path(:reset_password_token => $otp_token)
    else
      redirect_to otp_verification_admins_otp_verifications_path
      flash[:alert] = "Invalid OTP"
    end
  end

end
