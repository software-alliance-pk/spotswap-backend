user = @current_user
puts "###################"
puts @current_user.id
puts "###################"

connection = SwapperHostConnection.where(user_id: user.id).or(SwapperHostConnection.where(host_id: user.id))
if connection.present?
  json.swapper_host_connection do
    json.swapper_host_connection_id user.swapper_host_connection.id
    json.parking_slot_id user.swapper_host_connection.parking_slot_id
    json.connection_screen user.swapper_host_connection.connection_screen
    json.is_cancelled_by_swapper user.swapper_host_connection.is_cancelled_by_swapper
    json.confirmed_screen user.swapper_host_connection.confirmed_screen
    json.swapper user.swapper_host_connection.swapper
    json.host user.swapper_host_connection.host
    json.parking_slot user.swapper_host_connection.parking_slot
  end
else
  json.swapper_host_connection nil
end
