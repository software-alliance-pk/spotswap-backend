class UserStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_status_#{params[:conversation_id]}"
  end

  def unsubscribed
    stop_stream_from "user_status_#{params[:conversation_id]}"
  end
end
