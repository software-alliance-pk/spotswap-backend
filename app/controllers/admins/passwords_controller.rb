class Admins::PasswordsController < Devise::PasswordsController
  
  def create
    if Admin.last.email == params[:admin][:email]
      $otp = 6.times.map{rand(10)}.join
      super
    else
      redirect_to new_admin_password_path
      flash[:alert] = "Invalid Email"
    end 
  end

  private

  def after_sign_up_path_for(resource)
  end

  def after_sending_reset_password_instructions_path_for(resource)
    flash[:alert] = "Reset password link has been sent, please check your email."
    edit_admin_password_path(:reset_password_token => $otp_token)
  end

end
