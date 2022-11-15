class Api::V1::SwapperHostConnectionsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_connection, only: [:update_screen_navigation_flags, :destroy_connection]

  def create_connection
    return render json: {error: "parking slot id is missing."}, status: :unprocessable_entity unless params[:parking_slot_id].present?
    #return render json: {error: "You already have connection with host."}, status: :unprocessable_entity if is_current_user_already_has_connection

    @connection = @current_user.build_swapper_host_connection(connection_params)
    slot = ParkingSlot.find_by_id(params[:parking_slot_id])
    return render json: {error: "Parking Slot with this ID is not present."}, status: :unprocessable_entity unless slot.present?
    @connection.host_id = slot.user_id

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

  # def is_current_user_already_has_connection
  #   connection = SwapperHostConnection.where(user_id: @current_user.id).or(SwapperHostConnection.where(host_id: @current_user.id))
  #   return @current_user.swapper_host_connection.present?
  # end

end