class Api::V1::ParkingSlotsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_parking_slot, only: [:make_slot_available]
  before_action :slot_params, only: [:create_slot]
  before_action :params_check, only: [:get_all_spots, :get_all_finders]

  def create_slot
    if @current_user.host_swapper_connection.present? || @current_user.swapper_host_connection.present?
      return render json: {error: "You are Already in Connection."}, status: :unprocessable_entity
    else
      @parking_slot = @current_user.build_parking_slot(slot_params)
      if @parking_slot.save
        @parking_slot
      else
        render_error_messages(@parking_slot)
      end
    end
  end

  def make_slot_available
    unless @parking_slot.availability?
      @parking_slot.update(availability: true)
    end
  end

  def get_all_spots
    slots = ParkingSlot.within(0.6096, :units => :kms, :origin => [params[:latitude], params[:longitude]]).where.not(user_id: @current_user.id).available_slots
    @parking_slots = []
    slots.each do |slot|
      if slot_size_check(slot)
        @parking_slots << slot
      end
    end
  end

  def get_all_finders
    @users = User.within(0.6096, :units => :kms, :origin => [params[:latitude], params[:longitude]])
  end

  def transfer_slot
    return render json: {error: "User ID is missing in parameters."}, status: :unprocessable_entity unless params[:user_id].present?
    @slot = @current_user.parking_slot
    return render json: {error: "You have not any Parking Slot."}, status: :unprocessable_entity unless @slot.present?
    
    @user = User.find_by_id(params[:user_id])
    if @user.parking_slot.present?
      @user.parking_slot.destroy
    end

    if @slot.update(user_id: params[:user_id])
      @slot
    else
      render_error_messages(@slot)
    end
  end

  def notify_swapper_on_slot_transfer
    return render json: {error: "Connection Id is missing."}, status: :unprocessable_entity unless params[:connection_id].present?
    connection = SwapperHostConnection.find_by_id(params[:connection_id])
    return render json: {error: "Connection with this Id is not present."}, status: :unprocessable_entity unless connection.present?
    if PushNotificationService.notify_swapper_on_slot_transfer(connection).present?
      render json: {message: "Notification has been sent successfully to the Swapper."}, status: :ok
    else
      render json: {error: "Notification could not be sent."}, status: :unprocessable_entity
    end
  end

  def charge_amount
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      return render json: {error: "Payment Type is missing."}, status: :unprocessable_entity unless params[:payment_type].present?

      if params[:payment_type] == "paypal"
        return render json: {error: "PayPal Payment is not completed yet."}, status: :unprocessable_entity
      elsif params[:payment_type] == "credit_card"
        @charge_response = StripeChargeService.new.charge_amount_from_customer(params[:amount])
        @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(params[:amount])
      elsif params[:payment_type] == "wallet"
        @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(params[:amount])
      end
    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  def add_amount_to_wallet
    begin
      return render json: {error: "Amount is missing."}, status: :unprocessable_entity unless params[:amount].present?
      return render json: {error: "Referrer Code is missing."}, status: :unprocessable_entity unless params[:referrer_code].present?
      @referrer = User.find_by(referral_code: params[:referrer_code])
      return render json: {error: "Referral Code is InValid."}, status: :unprocessable_entity unless @referrer.present?
      @referral_code_record = check_referrer_code_already_in_use(@referrer)
      
      @topup_response = StripeTopUpService.new.create_top_up(params[:amount])  
      @wallet = @current_user.build_wallet(amount: new_amount_needs_to_add_in_wallet(params[:amount]))
      if @wallet.save
        @referral_code_record.update(is_top_up_created: true)
        @wallet
      else
        render_error_messages(@wallet)
      end
    rescue Exception => e
      render json: { error:  e.message }, status: :unprocessable_entity
    end
  end

  private

  def find_parking_slot
    return render json: {error: "Parking slot id parameter is missing"}, status: :unprocessable_entity  unless params[:id].present?
    @parking_slot =  ParkingSlot.find_by_id(params[:id])
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

  def get_wallet_previous_amount
    @current_user.wallet.amount
  end

  def new_amount_needs_to_add_in_wallet(amount)
    amount = amount.to_f + get_wallet_previous_amount
  end

  def check_referrer_code_already_in_use(referrer)
    record  = @current_user.user_referral_code_records.find_by(referrer_id: referrer.id)
    record = UserReferralCodeRecord.create(user_id: @current_user.id, user_code: @current_user.referral_code, referrer_code: referrer.referral_code, referrer_id: referrer.id) unless record.present?
    return record
  end
end