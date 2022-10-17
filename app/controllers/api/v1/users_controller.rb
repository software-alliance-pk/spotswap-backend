class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :user_params, only: [:update_user]
  
  def get_user
  end

  def update_user
    unless @current_user.update(user_params.merge(profile_complete: true))
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:id, :name, :email, :contact)
  end

end
