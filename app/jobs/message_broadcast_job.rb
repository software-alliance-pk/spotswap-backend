class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      converastion_id: message.conversation.id,
      content: message.body,
      sender: message.user,
    }
    ActionCable.server.broadcast(build_room_id(message.conversation.id), payload)
  end
  
  def build_room_id(id)
    "ChatRoom-#{id}"
  end
end