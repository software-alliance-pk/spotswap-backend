class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message)
    data = {}
    data["id"] = message.id
    data["conversation_id"] = message.conversation_id
    data["body"] = message.body
    data["user_id"] = message.user_id
    data["created_at"] = message.created_at
    data["updated_at"] = message.updated_at
    ActionCable.server.broadcast "conversations_#{message.conversation_id}", data.as_json
  end
end