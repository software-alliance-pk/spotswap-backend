class Admins::PasswordsController < Devise::PasswordsController
  
  private

  def after_sign_up_path_for(resource)
  end

  def after_sending_reset_password_instructions_path_for(resource)
    flash[:alert] = "Reset password link has been sent, please check your email."
    edit_admin_password_path(:reset_password_token => $otp_token)
  end

end
