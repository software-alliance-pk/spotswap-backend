class LocationTrackingChannel < ApplicationCable::Channel
  def subscribed
    connection = current_user.host_swapper_connection || current_user.swapper_host_connection  
    stream_from "swapper_location_tracking_with_connection_id_#{connection.id}" if connection.present?
  end

  def unsubscribed
    connection = current_user.host_swapper_connection || current_user.swapper_host_connection
    stop_stream_from "swapper_location_tracking_with_connection_id_#{connection.id}" if connection.present?
  end
end
