json.id conversation.id
json.sender_id conversation.sender_id
json.sender_name conversation.sender.name
json.sender_image conversation&.sender&.image.attached? ? conversation.sender.image.url : ""
json.recepient_id conversation.recepient_id
json.recepient_name conversation.recepient.name
json.recepient_image conversation&.recepient&.image&.attached? ? conversation.recepient.image.url : ""
json.sender_last_message_body conversation.sender&.messages&.last&.body? ? conversation.sender.messages.last.body : ""
json.is_blocked conversation.is_blocked
