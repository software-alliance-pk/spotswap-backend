class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_user
  before_action :user_params, only: [:update_user]
  
  def get_user
  end

  def update_user
    if params[:referrer_code].present?
      unless is_referral_code_valid(params[:referrer_code])
        return render json: { error: "Referral Code is Invalid." }, status: :unprocessable_entity
      end
      @user.referrer_code = params[:referrer_code] if params[:referrer_code].present?
      @user.referrer_id = @referrer_user.id if params[:referrer_code].present?
    end
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

  def is_referral_code_valid(code)
    @referrer_user = User.find_by(referral_code: code)
    return @referrer_user.present?
  end

end
