class UserStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_status_#{current_user.id}"
  end

  def unsubscribed
    stop_stream_from "user_status_#{current_user.id}"
  end
end
