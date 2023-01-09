class Admins::PasswordsController < Devise::PasswordsController
  
  def create
    if forget_password_params[:email].present?
      @admin  = Admin.find_by(email: forget_password_params[:email])
      if @admin.present?
        session[:admin_email_used_for_reset_password] = @admin.email
        @admin.otp = 6.times.map{rand(10)}.join
        @admin.save
        super
      else
        flash[:alert] = "No admin exist's against this email"
        redirect_to new_admin_password_path
      end
    else
      flash[:alert] = "Email can't be blank"
      redirect_to new_admin_password_path
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
      flash[:alert] = resource.errors.full_messages.last
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
