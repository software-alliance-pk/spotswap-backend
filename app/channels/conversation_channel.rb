class ConversationChannel < ApplicationCable::Channel
  # def subscribed
  #   stop_all_streams
  #   Conversation.where(user_1: current_user).or(Conversation.where(user_2: current_user)).find_each do |conversation|
  #       stream_from "conversations_#{conversation.id}"
  #   end
  # end

  # def unsubscribed
  #   stop_all_streams
  # end

  # def receive(data)
  #   @conversation = Conversation.find(data.fetch("conversation_id"))
  #   if (@conversation.user_1_id == current_user.id) || (@conversation.user_2_id == current_user.id)
  #       message_done = @conversation.messages.build(user_id: current_user.id)
  #       message_done.body = data["body"].present? ? data.fetch("body") : nil
  #     if message_done.save
  #       MessageRelayJob.perform_later(message_done)
  #     end
  #   end
  # end


  
  # calls when a client connects to the server
  def subscribed
    if params[:room_id].present?
      # creates a private chat room with a unique name
      stream_from("ChatRoom-#{(params[:room_id])}")
    end
  end
  
  # calls when a client broadcasts data
  def speak(data)
    sender    = get_sender(data)
    room_id   = data['room_id']
    message   = data['message']

    raise 'No room_id!' if room_id.blank?
    convo = get_convo(room_id) # A conversation is a room
    raise 'No conversation found!' if convo.blank?
    raise 'No message!' if message.blank?

    # adds the message sender to the conversation if not already included
    convo.users << sender unless convo.users.include?(sender)
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    Message.create!(
      conversation: convo,
      sender: sender,
      content: message
    )
  end
  
  # Helpers
  
  def get_convo(room_code)
    Conversation.find_by(room_code: room_code)
  end
  
  def get_sender
    User.find_by(guid: id)
  end
  
end
