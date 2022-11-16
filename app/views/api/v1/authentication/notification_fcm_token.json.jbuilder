if @connection.present?
  json.swapper_host_connection do
    json.swapper_host_connection_id  @connection.first.id
    json.parking_slot_id @connection.first.parking_slot_id
    json.connection_screen @connection.first.connection_screen
    json.is_cancelled_by_swapper @connection.first.is_cancelled_by_swapper
    json.confirmed_screen @connection.first.confirmed_screen
    json.swapper @connection.first.swapper
    json.host @connection.first.host
    json.parking_slot @connection.first.parking_slot
  end
else
  json.swapper_host_connection nil
end
