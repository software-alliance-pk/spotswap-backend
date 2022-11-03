class SupportMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      id: message.id,
      body: message.body,
      support_conversation_id: message.support_conversation_id,
      read_status: message.read_status,
      sender_id: message.sender_id,
      recepient_id: message.user_id,
      type: message.type,
      created_at: message.created_at,
      message_image: message.image.attached? ? message.image.url : "",
      sender_image: message.support_conversation.sender.image.attached? ? message.support_conversation.sender.image.url : ""
    }
    ActionCable.server.broadcast(build_support_conversation_id(message.support_conversation_id), payload)
  end
  
  def build_support_conversation_id(id)
    "support_conversation_#{id}"
  end
end