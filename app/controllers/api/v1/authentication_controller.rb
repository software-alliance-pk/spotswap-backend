class Api::V1::AuthenticationController < Api::V1::ApiController
  before_action :car_profile_params, only: [:create_car_profile, :update_car_profile]
  before_action :authorize_request, only: [:get_car_profile, :notification_fcm_token, :logout]
  before_action :check_the_params_of_request, only: [:update_car_profile]
  before_action :params_check_before_create_car_profile, only: [:create_car_profile]

  def login
    return render json: { error: "Email parameter is missing" }, status: :unprocessable_entity unless params[:email].present?
    return render json: { error: "Password parameter is missing" }, status: :unprocessable_entity unless params[:password].present?

    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      @token = JsonWebToken.encode(user_id: @user.id)
      @exp = (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")
    else
      render json: { error: "credentials are invalid." }, status: :unauthorized
    end
  end

  def sign_up
    if params[:referrer_code].present?
      unless is_referral_code_valid(params[:referrer_code])
        return render json: { error: "Referral Code is Invalid." }, status: :unprocessable_entity
      end
    end
    @user = User.new(sign_up_params.merge(profile_type: 'manual', profile_complete: false))
    @user.referrer_code = @referrer_user.referral_code if params[:referrer_code].present?
    @user.referrer_id = @referrer_user.id if params[:referrer_code].present?
    if @user.save
      @token = JsonWebToken.encode(user_id: @user.id)
    else
      render_error_messages(@user)
    end
  end

  def notification_fcm_token
    return render json: { error: "FCM token parameter is missing"}, status: :unprocessable_entity unless params[:fcm_token].present?
    return render json: { error: "Latitude parameter is missing"}, status: :unprocessable_entity unless params[:latitude].present?
    return render json: { error: "Longitude parameter is missing "}, status: :unprocessable_entity unless params[:longitude].present?
    return render json: { error: "Address parameter is missing"}, status: :unprocessable_entity unless params[:address].present?
    if @current_user.present?
        @current_user.update(latitude: params[:latitude], longitude: params[:longitude], address: params[:address])
        user = @current_user.build_mobile_device(mobile_device_token: params[:fcm_token])
        if user.save
         @connection = SwapperHostConnection.where(user_id: @current_user.id).or(SwapperHostConnection.where(host_id: @current_user.id))
        else
          render json: { error: "fcm token could not associated with user, something went wrong." }, status: :unprocessable_entity
        end
    else
      render json: { error: "current user is missing." }, status: :unprocessable_entity
    end
  end

  def logout
    fcm_token = @current_user.mobile_device
    if fcm_token.present?
      fcm_token.destroy
      @current_user.update(is_online: false)
      render json: { message: "Log out successfully." }, status: :ok
    else
      render json: { error: "User has not any mobile device token." }, status: :unprocessable_entity
    end
  end

  def create_car_profile
    user = User.find_by(id: params[:user_id])
    return render json: { error: "User with this Id does not exist." }, status: :unprocessable_entity unless user.present?
    return render json: { error: "Car Brand with this Id does not exist." }, status: :unprocessable_entity unless CarBrand.find_by(id: car_profile_params[:car_brand_id]).present?
    return render json: { error: "Car Model with this Id does not exist." }, status: :unprocessable_entity unless CarModel.find_by(id: car_profile_params[:car_model_id]).present?

    @car_detail = user.build_car_detail(car_profile_params.except(:user_id, :car_brand_id, :car_model_id))
    if @car_detail.save
      user_car_brand = @car_detail.build_user_car_brand(car_brand_id: params[:car_brand_id])
      if user_car_brand.save
        user_car_model = @car_detail.build_user_car_model(car_model_id: params[:car_model_id])
        if user_car_model.save
          user.profile_complete = true
          user.status = "active"
          user.is_info_complete = true
          user.save
        end
      end
    end
  end

  def update_car_profile
    @car_detail = CarDetail.find_by_id(params[:id])
    return render json: { error: "car detail with this id is not present." }, status: :unprocessable_entity unless @car_detail.present?
    @car_detail.is_show = params[:is_show]
    
    if @car_detail.update(car_profile_params.except(:user_id, :car_brand_id, :car_model_id))
      @user_car_brand = @car_detail.build_user_car_brand(car_brand_id: params[:car_brand_id])
      if @user_car_brand.save
        @user_car_model = @car_detail.build_user_car_model(car_model_id: params[:car_model_id])        
        if @user_car_model.save
          @car_detail
        else
          render_error_messages(@user_car_model)
        end
      else
        render_error_messages(@user_car_brand)
      end
    else
      render_error_messages(@car_detail)
    end
  end

  def get_car_specification
    @info = CarBrand.all
  end

  def get_car_profile
    return render json: { error: "car detail with this id is not present." }, status: :unprocessable_entity  unless params[:id].present?
    @car_detail = CarDetail.find_by_id(params[:id])
    if @car_detail.present?
      @car_detail
    else
      render json: { error: "car detail with this id is not present." }, status: :unprocessable_entity
    end
  end

  private

  def check_the_params_of_request
    return render json: { error: "Id parameter is missing" },status: :unprocessable_entity unless params[:id].present?
    return render json: { error: "Length parameter is missing"  },status: :unprocessable_entity unless params[:length].present?
    return render json: { error: "Width parameter is missing" },status: :unprocessable_entity unless params[:width].present?
    return render json: { error: "Height parameter is missing"  },status: :unprocessable_entity unless params[:height].present?
    return render json: { error: "Color parameter is missing" },status: :unprocessable_entity unless params[:color].present?
    return render json: { error: "Is show parameter is missing" },status: :unprocessable_entity unless params[:is_show].present?
    return render json: { error: "Car brand id parameter is missing" },status: :unprocessable_entity unless params[:car_brand_id].present?
    return render json: { error: "Car model parameter is missing" },status: :unprocessable_entity unless params[:car_model_id].present?
  end

  def params_check_before_create_car_profile
    return render json: { error: "User Id is missing in params." }, status: :unprocessable_entity unless car_profile_params[:user_id].present?
    return render json: { error: "Car Brand Id is missing in params." }, status: :unprocessable_entity unless car_profile_params[:car_brand_id].present?
    return render json: { error: "Car Model Id is missing in params." }, status: :unprocessable_entity unless car_profile_params[:car_model_id].present?
  end
  
  def login_params
    params.permit(:email, :password)
  end

  def sign_up_params
    params.permit(:name, :email, :contact, :country_code, :password, :latitude, :longitude, :address, :image)
  end

  def car_profile_params
    params.permit(:length, :width, :height, :color, :plate_number, :user_id, :car_brand_id, :car_model_id, :photos => [])
  end

  def is_referral_code_valid(code)
    @referrer_user = User.find_by(referral_code: code)
    return @referrer_user.present?
  end

end
