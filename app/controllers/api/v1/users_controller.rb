class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_user
  before_action :user_params, only: [:update_user]
  before_action :social_login_user_params, only: [:update_social_login_user]

  def get_user
  end

  def update_user
    unless @user.update(user_params.merge(profile_complete: true))
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find_by_id(params[:id])
    if !@user.present?
      render json: { errors: 'User not found' }, status: :not_found
    end
  end

  def user_params
    params.permit(:id, :name, :email, :contact)
  end

end
