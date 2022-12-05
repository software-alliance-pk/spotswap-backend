class ConversationChannel < ApplicationCable::Channel 
  # calls when a client connects to the server
  def subscribed
    if params[:conversation_id].present?
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      params
      puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      stream_from("conversation_#{(params[:conversation_id])}")
      # @conversation = Conversation.find_by(id: params[:conversation_id])
      # if @conversation.present?
      #   @conversation_sender = @conversation&.sender
      #   @conversation_recepient = @conversation&.recepient
        
      #   stream_from("conversation_#{(params[:conversation_id])}")
      #   ActionCable.server.broadcast "user_status",
      #   {
      #     user_id: current_user.id, online: :true,
      #     conversation_sender_id: @conversation_sender.id,
      #     conversation_sender_status: @conversation_sender.is_online,
      #     conversation_recipient_id: @conversation_recepient.id,
      #     conversation_recipient_status: @conversation_recepient.is_online
      #   }
      # else
      #   puts "conversation with this id is not present."
      # end
    else
      puts "conversation id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
