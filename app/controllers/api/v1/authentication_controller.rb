class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :create_car_profile_params, only: [:create_car_profile]
  before_action :authorize_request, only: [:get_car_profile, :notification_fcm_token, :logout]

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      @token = JsonWebToken.encode(user_id: @user.id)
      @exp = (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")
    else
      render json: { error: "credentials are invalid." }, status: :unauthorized
    end
  end

  def sign_up
    @user = User.new(sign_up_params.merge(profile_type: 'manual', profile_complete: false))
    if @user.save
      @token = JsonWebToken.encode(user_id: @user.id)
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def notification_fcm_token
    if params.values_at(*%i( fcm_token latitude longitude address )).all?(&:present?)
      if @current_user.update(latitude: params[:latitude], longitude: params[:longitude], address: params[:address])
      else
        render json: { error: "params latitude, longitude and address could not updated, something went wrong." }, status: :unprocessable_entity
      end

      if @current_user.mobile_devices.create(mobile_device_token: params[:fcm_token])
        render json: { message: "fcm token has been associated with user.", fcm_token: params[:fcm_token] }, status: :ok
      else
        render json: { error: "fcm token could not associated with user, something went wrong." }, status: :unprocessable_entity
      end
    else
      render json: { error: "all params fcm_token, latitude, longitude and address must present." }, status: :unprocessable_entity
    end
  end

  def logout
    fcm_token = @current_user.mobile_devices
    if fcm_token.present?
      fcm_token.destroy
      render json: { message: "Log out successfully" }, status: :ok
    else
      render json: { message: "Something went wrong" }, status: :unprocessable_entity
    end
  end

  def create_car_profile
    if create_car_profile_params[:user_id].present? && create_car_profile_params[:car_brand_id].present? && create_car_profile_params[:car_model_id].present?
      user = User.find_by(id: params[:user_id])
      if user.present?
        ActiveRecord::Base.transaction do
          user.profile_complete = true
          user.save
          @car_detail = user.build_car_detail(create_car_profile_params.except(:user_id, :car_brand_id, :car_model_id))
          if @car_detail.save
            user_car_brand = @car_detail.build_user_car_brand(car_brand_id: params[:car_brand_id])
            if user_car_brand.save
              user_car_model = @car_detail.build_user_car_model(car_model_id: params[:car_model_id])
              if user_car_model.save
                @car_detail
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
        render json: { message: "User does not exists against this id." }
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
          if @user_car_brand.save
          else
            render json: { errors: @user_car_brand.errors.full_messages }, status: :unprocessable_entity
          end
        end
        if params[:car_model_id].present?
          @user_car_model = @car_detail.build_user_car_model(car_model_id: params[:car_model_id])
          if @user_car_model.save
          else
            render json: { errors: @user_car_model.errors.full_messages }, status: :unprocessable_entity
          end
        end
      else
        render json: { errors: @car_detail.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "car detail with this id is not present."}
    end
  end

  def get_car_specification
    @info =  CarBrand.all
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
    params.permit(:name, :email, :contact, :password, :latitude, :longitude, :address, :image)
  end

  def create_car_profile_params
    params.permit(:length, :color, :plate_number, :user_id, :car_brand_id, :car_model_id, :photos => [])
  end

end
