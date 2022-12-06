class UserStatusChannel < ApplicationCable::Channel

  def subscribed
    puts params
    if params[:user_id].present?
      stream_from "user_status_#{(params[:user_id])}"
      @conversation = Conversation.find_by(id: params[:conversation_id])
      if @conversation.present?
        if @conversation.user_id == params[:user_id].to_i
          @user = @conversation.recepient
        elsif @conversation.recepient_id == params[:user_id].to_i
          @user = @conversation.sender
        end
        if @user.present?
          stream_from("conversation_#{(params[:conversation_id])}")
          ActionCable.server.broadcast "user_status_#{@user.id}",
          {
            user_id: @user.id,
            user_online_status: @user.is_online,
          }
        end
      else
        puts "conversation with this id is not present."
      end
    else
      puts "User Id is missing."
    end
  end
end
