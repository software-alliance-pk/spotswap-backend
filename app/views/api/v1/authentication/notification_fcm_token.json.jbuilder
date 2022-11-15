user = @current_user
if user.swapper_host_connection.present?
  json.swapper_host_connection do
    json.swapper_host_connection_id user.swapper_host_connection.id
    json.parking_slot_id user.swapper_host_connection.parking_slot_id
    json.connection_screen user.swapper_host_connection.connection_screen
    json.is_cancelled_by_swapper user.swapper_host_connection.is_cancelled_by_swapper
    json.confirmed_screen user.swapper_host_connection.confirmed_screen
    json.swapper user.swapper_host_connection.user
    json.host user.swapper_host_connection.parking_slot.user
    json.parking_slot user.swapper_host_connection.parking_slot
  end
else
  json.swapper_host_connection nil
end
