class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      support_conversation_id: message.support_conversation_id,
      content: message.body,
      sender: message.user
    }
    ActionCable.server.broadcast(build_support_conversation_id(message.support_conversation_id), payload)
  end
  
  def build_support_conversation_id(id)
    "support_conversation_#{id}"
  end
end