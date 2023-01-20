json.swapper_host_connection do
  json.connection_id @connection.id
  json.parking_slot_id @connection.parking_slot_id
  json.connection_screen @connection.connection_screen
  json.is_cancelled_by_swapper @connection.is_cancelled_by_swapper
  json.confirmed_screen @connection.confirmed_screen
  json.swapper @connection.swapper
  json.host @connection.host
  json.parking_slot @connection.parking_slot
  json.parking_slot_image @connection.parking_slot.image.attached? ? @connection.parking_slot.image.url : ""
end