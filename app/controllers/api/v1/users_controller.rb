class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_user
  before_action :user_params, only: [:update_user]
  
  def get_user
  end

  def update_user
    if @user.update(user_params.merge(is_info_complete: true))
      @user
    else
      render_error_messages(@user)
    end
  end

  private
  def find_user
    @user = @current_user
  end

  def user_params
    params.permit(:id, :name, :email, :contact, :image, :country_code)
  end

end
