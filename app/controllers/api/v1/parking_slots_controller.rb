class Api::V1::ParkingSlotsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_parking_slot, only: [:make_slot_available]
  before_action :slot_params, only: [:create_slot]

  def create_slot
    @parking_slot = ParkingSlot.new(slot_params)
    if @parking_slot.save
      @parking_slot
    else
      render_error_messages(@parking_slot)
    end   
  end

  def make_slot_available
    if @parking_slot.present?
      if @parking_slot.availability?
        if @parking_slot.update(availability: true)
          @parking_slot
        else
          render_error_messages(@parking_slot)
        end
      else
        @parking_slot
      end
    else
      render json: { error: "parking slot with this id is not present."}, status: :unprocessable_entity
    end
  end

  private

  def find_parking_slot
    return render json: {error: "Parking slot id parameter is missing"},status: :unprocessable_entity  unless params[:id].present?
    @parking_slot = ParkingSlot.find_by_id(params[:id])
    return render json: {error: "No such Parking slot is present"}, status: :unprocessable_entity unless @parking_slot.present?
  end

  def slot_params
    params.permit(:id, :description, :image, :availability)
  end
end