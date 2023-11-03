class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit additional parameters for sign-up and account update
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :username, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :username, :email])
  end
end
