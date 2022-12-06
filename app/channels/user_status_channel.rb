class UserStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_appearance_status"
  end

  def unsubscribed
    stop_stream_from "user_appearance_status"
  end
end
