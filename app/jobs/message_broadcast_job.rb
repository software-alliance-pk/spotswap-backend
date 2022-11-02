class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      conversation_id: message.conversation_id,
      content: message.body,
      sender: message.user
    }
    ActionCable.server.broadcast(build_conversation_id(message.conversation_id), payload)
  end
  
  def build_conversation_id(id)
    "conversation_#{id}"
  end
end