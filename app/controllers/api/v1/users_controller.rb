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

  def update_user_status
    return render json: { error: "User Current Status is missing in params." }, status: :unprocessable_entity unless params[:current_status].present?
    wallet_amount = @current_user.wallet.present? ? @current_user.wallet.amount : "0"
    if params[:current_status] == "online"
      @current_user.update(is_online: true)
      ActionCable.server.broadcast("user_appearance_status", {
        title: 'Online Status',
        body: {online: true, user_id: @current_user.id}
      })
      return render json: { message: "User Current Status is set to Online.", wallet_amount: wallet_amount }, status: :ok
    elsif params[:current_status] == "offline"
      @current_user.update(is_online: false)
      ActionCable.server.broadcast("user_appearance_status", {
        title: 'Online Status',
        body: {online: false, user_id: @current_user.id}
      })
      return render json: { message: "User Current Status is set to Offline.", wallet_amount: wallet_amount }, status: :ok
    else
      return render json: { error: "Value of User Current Status is incorrect in params." }, status: :unprocessable_entity
    end
  end

  def swapper_location_tracking
    if @current_user.swapper_host_connection.present?
      # connection = @current_user.swapper_host_connection
      # swapper = connection.swapper
      @current_user.update(latitude: params[:latitude], longitude: params[:longitude], address: params[:address])
      ActionCable.server.broadcast("swapper_location_tracking_with_connection_id_#{@current_user.swapper_host_connection.id}", {
          title: 'swapper_location_updated',
          body: {swapper_id: @current_user.id , swapper_address: @current_user.address, swapper_latitude: @current_user.latitude, swapper_longitude: @current_user.longitude}
        })
      return render json: { message: "User's current location has been updated.", swapper: @current_user}, status: :ok
    else
      return render json: { error: "You have not any swapper host connection."}, status: :unprocessable_entity
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
