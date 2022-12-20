class Api::V1::SwapperHostConnectionsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_connection, only: [:update_screen_navigation_flags, :destroy_connection]

  def create_connection
    return render json: {error: "Parking Slot ID is missing."}, status: :unprocessable_entity unless params[:parking_slot_id].present?
    slot = ParkingSlot.find_by_id(params[:parking_slot_id])
    return render json: {error: "Parking Slot with this ID is not present."}, status: :unprocessable_entity unless slot.present?
    connected_user = @current_user == @connection_check.first.host ? @connection_check.first.swapper : @connection_check.first.host unless is_current_user_already_has_connection.empty?
    return render json: {error: "You already have connection with #{connected_user.name}."}, status: :unprocessable_entity unless is_current_user_already_has_connection.empty?
    @connection = @current_user.build_swapper_host_connection(connection_params)
    @connection.host_id =  slot.user.id
    if @connection.save
      @connection
    else
      render_error_messages(@connection)
    end
  end

  def update_screen_navigation_flags
    if @connection.update(update_screen_params)
      @connection
    else
      render_error_messages(@connection)
    end
  end

  def destroy_connection
    if @connection.destroy
      render json: {message: "Swapper connection with host has been cancelled successfully."}, status: :ok
    else
      render_error_messages(@connection)
    end
  end

  def notify_host_on_cancel_request
    return render json: {error: "Swapper Id is missing."}, status: :unprocessable_entity unless params[:swapper_id].present?
    @user = User.find_by_id(params[:swapper_id])
    @connection = SwapperHostConnection.find_by(user_id: @user.id)
    return render json: {error: "Swapper with given Id has not any Swapper Host Connection."}, status: :unprocessable_entity unless @connection.present?
    if PushNotificationService.notify_host_on_cancel_request(@user).present?
      render json: {message: "Notification has been sent successfully to the Host."}, status: :ok
    else
      render json: {error: "Notification could not be sent."}, status: :unprocessable_entity
    end
  end

  def notify_swapper_for_confirm_arrival
    return render json: {error: "Swapper Id is missing."}, status: :unprocessable_entity unless params[:swapper_id].present?
    @user = User.find_by_id(params[:swapper_id])
    @connection = SwapperHostConnection.find_by(user_id: @user.id)
    return render json: {error: "Other user unable to acknowledge the connection in Time."}, status: :unprocessable_entity unless @connection.present?
    if PushNotificationService.notify_swapper_for_confirm_arrival(@user).present?
      render json: {message: "Notification has been sent successfully to the Swapper."}, status: :ok
    else
      render json: {error: "Notification could not be sent."}, status: :unprocessable_entity
    end
  end

  def notify_host_swapper_is_still_interested
    return render json: {error: "Connection Id is missing."}, status: :unprocessable_entity unless params[:connection_id].present?
    connection = SwapperHostConnection.find_by_id(params[:connection_id])
    return render json: {error: "Connection with this Id is not present."}, status: :unprocessable_entity unless connection.present?
    if PushNotificationService.notify_host_swapper_is_still_interested(connection).present?
      render json: {message: "Notification has been sent successfully to the Host."}, status: :ok
    else
      render json: {error: "Notification could not be sent."}, status: :unprocessable_entity
    end
  end

  private

  def connection_params
    params.permit(:parking_slot_id)
  end

  def update_screen_params
    params.permit(:id, :connection_screen, :is_cancelled_by_swapper, :confirmed_screen)
  end

  def find_connection
    return render json: {error: "connection id is missing."}, status: :unprocessable_entity unless params[:connection_id].present?
    @connection = SwapperHostConnection.find_by_id(params[:connection_id])
    return render json: {error: "swapper host connection with this id is not present."}, status: :unprocessable_entity unless @connection.present?
  end

  def is_current_user_already_has_connection
    @connection_check = SwapperHostConnection.where(user_id: @current_user.id).or(SwapperHostConnection.where(host_id: @current_user.id))
    return @connection_check
  end

end