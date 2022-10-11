class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    Conversation.where(user_1: current_user).or(Conversation.where(user_2: current_user)).find_each do |conversation|
        stream_from "conversations_#{conversation.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    @conversation = Conversation.find(data.fetch("conversation_id"))
    if (@conversation.user_1_id == current_user.id) || (@conversation.user_2_id == current_user.id)
        message_done = @conversation.messages.build(user_id: current_user.id)
        message_done.body = data["body"].present? ? data.fetch("body") : nil
      if message_done.save
        MessageRelayJob.perform_later(message_done)
      end
    end
  end
  
end
