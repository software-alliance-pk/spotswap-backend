class Admins::PasswordsController < Devise::PasswordsController
  
  def create
    if params[:admin][:email]==''
      redirect_to new_admin_password_path
      flash[:alert] = "Email can't be blank"
    elsif Admin.pluck(:email).include?(params[:admin][:email])
      $otp = 6.times.map{rand(10)}.join
      super
    else
      redirect_to new_admin_password_path
      flash[:alert] = "Invalid Email"
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      flash[:notice] = resource.errors.full_messages.last
      redirect_to edit_admin_password_path(reset_password_token: resource_params[:reset_password_token])
    end
  end

  private

  def after_sign_up_path_for(resource)
  end

  def after_sending_reset_password_instructions_path_for(resource)
    otp_verification_admins_otp_verifications_path
  end

  def forget_password_params
    params.require(:admin).permit(:email)
  end
end
