class Api::V1::AuthenticationController < Api::V1::ApiController

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      @token = JsonWebToken.encode(user_id: @user.id)
      @exp = (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")
    else
      render json: { error: "credentials are invalid." }, status: :unauthorized
    end
  end

  # POST /auth/sign_up
  def sign_up
    @user = User.new(sign_up_params)
    if @user.save
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def get_car_brands
    @car_brands = CarBrand.all
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def sign_up_params
    params.permit(
      :name, :email, :contact, :password
    )
  end
end
