class ConversationChannel < ApplicationCable::Channel 
  # calls when a client connects to the server
  def subscribed
    if params[:conversation_id].present?
      stream_from("conversation_#{(params[:conversation_id])}")
      current_user.update!(is_online: true)
      ActionCable.server.broadcast "user_status", { user: current_user.id, online: :true }
    else
      puts "conversation id is missing."
    end
  end

  def unsubscribed
    current_user.update!(is_online: false)
    ActionCable.server.broadcast "user_status", { user: current_user.id, online: :false }
    stop_all_streams
  end
end
