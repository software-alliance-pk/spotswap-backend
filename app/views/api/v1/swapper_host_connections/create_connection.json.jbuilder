json.swapper_host_connection do
  json.connection_id @connection.id
  json.parking_slot_id @connection.parking_slot_id
  json.connection_screen @connection.connection_screen
  json.is_cancelled_by_swapper @connection.is_cancelled_by_swapper
  json.confirmed_screen @connection.confirmed_screen
  json.swapper @connection.swapper
  json.host @connection.host
  json.parking_slot do
    json.id @connection.parking_slot.id
    json.description @connection.parking_slot.description
    json.latitude @connection.parking_slot.latitude
    json.longitude @connection.parking_slot.longitude
    json.address @connection.parking_slot.address
    json.availability @connection.parking_slot.availability
    json.user_id @connection.parking_slot.user_id
    json.parking_slot_image @connection.parking_slot.image.attached? ? @connection.parking_slot.image.url : ""
  end
end