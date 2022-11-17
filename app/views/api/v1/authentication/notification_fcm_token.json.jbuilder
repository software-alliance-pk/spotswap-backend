if @connection.present?
  json.swapper_host_connection do
    json.swapper @connection.first.swapper
    json.host @connection.first.host
    json.parking_slot @connection.first.parking_slot
    json.swapper_host_connection_id @connection.first.id
    json.confirmed_screen @connection.first.confirmed_screen
    @temp = @current_user == @connection.first.host ? @connection.first.swapper : @connection.first.host
    json.car_model_name @temp&.car_detail&.car_model&.title
    json.user_image @temp.image.attached? ? @temp.image.url : ""
    json.car_image @temp.car_detail&.photos&.attached? ? @temp.car_detail.photos[0].url : ""
    json.parking_slot_image @connection.first.parking_slot.image.attached? ? @connection.first.parking_slot.image.url : ""
  end
else
  json.swapper_host_connection nil
end
