class UserStatusChannel < ApplicationCable::Channel

  def subscribed
    if params[:user_id].present?
      stream_from "user_status_#{(params[:user_id])}"
      puts params
      @conversation = Conversation.find_by(id: params[:conversation_id])
      puts @conversation.present?
      puts @conversation.user_id
      puts @conversation.recepient_id
      
      if @conversation.present?
        puts "1111111111111111"
        if @conversation.user_id == params[:user_id].to_i
          puts "22222"
          @user = @conversation.recepient
        elsif @conversation.recepient_id == params[:user_id].to_i
          puts "33333333333"
          @user = @conversation.sender
          puts @user
        end
        if @user.present?
          puts "444444444444"
          stream_from("conversation_#{(params[:conversation_id])}")
          payload = ActionCable.server.broadcast "user_status_#{@user.id}",
          {
            user_id: @user.id,
            user_online_status: @user.is_online,
          }
          puts payload
        end
      else
        puts "conversation with this id is not present."
      end
    else
      puts "User Id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
  end 
end
