class LocationTrackingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "swapper_location_tracking"
  end

  def unsubscribed
    stop_stream_from "swapper_location_tracking"
  end
end
