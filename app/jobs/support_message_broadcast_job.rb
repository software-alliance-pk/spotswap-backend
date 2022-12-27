class SupportMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      id: message.id,
      body: message.body,
      support_conversation_id: message.support_conversation_id,
      ticket_number: message.support_conversation.support,
      read_status: message.read_status,
      sender_id: message.sender,
      sender_name: message.support_conversation.sender_name,
      recepient_id: message.support_conversation.recipient,
      recepient_name: message.support_conversation.recipient_full_name,
      type: message.type,
      created_at: message.created_at.strftime("%H:%M"),
      user_id: message.user_id,
      message_image: message.image.attached? ? message.image.url : "",
      sender_image: message.support_conversation.sender_image.attached? ? message.support_conversation.sender_image.url : "",
      recepient_image: message.support_conversation.recipient_image.attached? ? message.support_conversation.recipient_image.url : ""
    }
    ActionCable.server.broadcast(build_support_conversation_id(message.support_conversation_id), payload)
  end
  
  def build_support_conversation_id(id)
    "support_conversation_#{id}"
  end
end