class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :create_car_details_params, only: [:create_car_details]

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
      @token = JsonWebToken.encode(user_id: @user.id)
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_car_details
    user = User.find_by(id: params[:user_id])
    ActiveRecord::Base.transaction do
      car_detail = user.build_car_detail(create_car_details_params.except(:user_id, :car_brand_id, :car_model_id))
      if car_detail.save
        user_car_brand = car_detail.build_user_car_brand(car_brand_id: params[:car_brand_id])
        if user_car_brand.save
          user_car_model = car_detail.build_user_car_model(car_model_id: params[:car_model_id])
          if user_car_model.save
            car_detail.default_image.attach(params[:default_image])
            car_detail.photos.attach(params[:photos])
            render json: { message: "User's Car Details have been created successfully." }
          else
            render json: { errors: user_car_model.errors.full_messages }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
        else
          render json: { errors: user_car_brand.errors.full_messages }, status: :unprocessable_entity
          raise ActiveRecord::Rollback

        end
      else
        render json: { errors: car_detail.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def get_car_brands
    @car_brands = CarBrand.all
  end

  def get_car_models
    @car_models = CarModel.all
  end

  def get_car_profile
    @car_detail = CarDetail.find_by(id: params[:id]) if params[:id].present?
    if @car_detail.present?
    else
      render json: { message: "car detail with this id is not present." }
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def sign_up_params
    params.permit(:name, :email, :contact, :password)
  end

  def create_car_details_params
    params.permit(:length, :color, :plate_number, :user_id, :car_brand_id, :car_model_id, :default_image, :photos)
  end
end
