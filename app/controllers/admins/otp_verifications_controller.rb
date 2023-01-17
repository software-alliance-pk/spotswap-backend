class Admins::OtpVerificationsController < ApplicationController
 
  def otp_verification
    @email = Admin.find_by(email: session[:admin_email_used_for_reset_password])&.email
  end
 
  def verify_otp
    @admin = Admin.find_by(email: reset_password_params[:email])
    if combine_otp&.present?
      if  @admin.otp == combine_otp
        redirect_to edit_admin_password_path(:reset_password_token => @admin.otp)
      else
        flash[:notice] = "OTP does n't match"
        redirect_to otp_verification_admins_otp_verifications_path
      end
    else
      flash[:notice] = "OTP can't be blank"
      redirect_to otp_verification_admins_otp_verifications_path
    end
  end


  def reset_password_params
    params.require(:otp).permit(:email,:first_digit,:second_digit,:third_digit,:fourth_digit,:fifth_digit,:sixth_digit)
  end

  def combine_otp
    reset_password_params[:first_digit]+reset_password_params[:second_digit]+reset_password_params[:third_digit]+reset_password_params[:fourth_digit]+
      reset_password_params[:fifth_digit]+reset_password_params[:sixth_digit]
  end

end
