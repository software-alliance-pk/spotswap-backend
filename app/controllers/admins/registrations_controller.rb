class Admins::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        $is_from_sign_up = "yes"
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource) and return
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:alert] = resource.errors.full_messages.last
      redirect_to new_admin_registration_path
    end
  end
end
