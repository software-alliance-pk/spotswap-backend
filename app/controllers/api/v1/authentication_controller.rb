class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :create_car_profile_params, only: [:create_car_profile]

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

  def create_car_profile
    if params[:user_id].present? && params[:car_brand_id].present? && params[:car_model_id].present?
      user = User.find_by(id: params[:user_id])
      if user.present?
        ActiveRecord::Base.transaction do
          @car_detail = user.build_car_detail(create_car_profile_params.except(:user_id, :car_brand_id, :car_model_id))
          if @car_detail.save
            user_car_brand = @car_detail.build_user_car_brand(car_brand_id: params[:car_brand_id])
            if user_car_brand.save
              user_car_model = @car_detail.build_user_car_model(car_model_id: params[:car_model_id])
              if user_car_model.save
                @car_detail.photos.attach(params[:photos])
              else
                render json: { errors: user_car_model.errors.full_messages }, status: :unprocessable_entity
                raise ActiveRecord::Rollback
              end
            else
              render json: { errors: user_car_brand.errors.full_messages }, status: :unprocessable_entity
              raise ActiveRecord::Rollback

            end
          else
            render json: { errors: @car_detail.errors.full_messages }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
        end
      else
        render json: { message: "invalid user id." }
      end
    else
      render json: { message: "user_id, car_brand_id and car_model_id should be present." }
    end
  end

  def update_car_profile
    @car_detail = CarDetail.find_by(id: params[:id]) if params[:id].present?
    if @car_detail.present?
      @car_detail.length = params[:length] if params[:length].present?
      @car_detail.color = params[:color] if params[:color].present?
      @car_detail.plate_number = params[:plate_number] if params[:plate_number].present?

      if params[:photos].present?
        @car_detail.photos.purge
        @car_detail.photos.attach(params[:photos])
      end

      if @car_detail.save
        if params[:car_brand_id].present?
          @user_car_brand = @car_detail.build_user_car_brand(car_brand_id: params[:car_brand_id])
          render json: { errors: @user_car_brand.errors.full_messages }, status: :unprocessable_entity if !@user_car_brand.save
        end
        if params[:car_model_id].present?
          @user_car_model = @car_detail.build_user_car_model(car_model_id: params[:car_model_id])
          render json: { errors: @user_car_model.errors.full_messages }, status: :unprocessable_entity if !@user_car_model.save
        end
      else
        render json: { errors: @car_detail.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "car detail with this id is not present."}
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

  def create_car_profile_params
    params.permit(:length, :color, :plate_number, :user_id, :car_brand_id, :car_model_id, :photos => [])
  end

end
