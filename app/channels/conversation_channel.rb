class ConversationChannel < ApplicationCable::Channel 
  # calls when a client connects to the server
  def subscribed
    if params[:conversation_id].present?
      stream_from("conversation_#{(params[:conversation_id])}")
    else
      puts "conversation id is missing."
    end
  end

  def unsubscribed
    stop_all_streams
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
