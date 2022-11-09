class Api::V1::ParkingSlotsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_parking_slot, only: [:make_slot_available]
  before_action :slot_params, only: [:create_slot]
  before_action :params_check, only: [:get_all_spots, :get_all_finders]


  def create_slot
    puts "#######"
    puts @current_user.parking_slots.build
    puts "#######"

    @parking_slot = @current_user.parking_slots.build(slot_params)
    if @parking_slot.save
      @parking_slot
    else
      render_error_messages(@parking_slot)
    end   
  end

  def make_slot_available
    unless @parking_slot.availability?
      @parking_slot.update(availability: true)
    end
  end

  def get_all_spots
    slots = ParkingSlot.within(0.6096, :units => :kms, :origin => [params[:latitude], params[:longitude]]).available_slots
    @parking_slots = []
    slots.each do |slot|
      if slot_size_check(slot)
        @parking_slots.push(slot)
      end
    end
  end

  def get_all_finders
    @users = User.within(0.6096, :units => :kms, :origin => [params[:latitude], params[:longitude]])
  end

  private

  def find_parking_slot
    return render json: {error: "Parking slot id parameter is missing"},status: :unprocessable_entity  unless params[:id].present?
    @parking_slot = ParkingSlot.find_by_id(params[:id])
    return render json: {error: "No such Parking slot is present"}, status: :unprocessable_entity unless @parking_slot.present?
  end

  def slot_params
    params.permit(:description, :image, :longitude, :latitude, :address)
  end

  def slot_size_check(slot)
    return slot&.user&.car_detail&.length >= @current_user&.car_detail&.length
  end

  def params_check
    return render json: {error: "Latitude param is missing."}, status: :unprocessable_entity unless params[:latitude].present?
    return render json: {error: "Longitude param is missing."}, status: :unprocessable_entity unless params[:longitude].present?
  end
  
end