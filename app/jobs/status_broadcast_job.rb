class StatusBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user)
    @conversations = Conversation.where(user_id: user.id).or(Conversation.where(recepient_id: user.id))
    @conversations.each do |conversation|
      payload = {
        recipient_id: conversation.recepient.id,
        recipient_online_status: conversation.recepient.is_online,
        sender_id: conversation.sender.id,
        sender_online_status: conversation.sender.is_online,
        type: "user_status"
      }
      ActionCable.server.broadcast(build_conversation_id(conversation.id), payload)
    end
  end
  
  def build_conversation_id(id)
    "conversation_#{id}"
  end
end