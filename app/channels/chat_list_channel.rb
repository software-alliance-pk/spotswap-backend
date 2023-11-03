class ChatListChannel < ApplicationCable::Channel 
  # calls when a client connects to the server
  def subscribed
    stream_from "user_chat_list_#{current_user.id}"
  end

  def unsubscribed
    stop_stream_from "user_chat_list__#{current_user.id}"
  end
  
end
