json.id message.id
json.body message.body
json.read_status message.read_status
json.sender_id message.conversation.sender.id
json.sender_name message.conversation.sender_name
json.recepient_id message.conversation.recepient.id
json.recepient_name message.conversation.recepient_name
json.created_at message.created_at
json.conversation_id message.conversation_id
json.message_image message.image.attached? ? message.image.url : ""
json.sender_image message.conversation.sender_image.attached? ? message.conversation.sender_image.url : ""
json.recepient_image message.conversation.recepient_image.attached? ? message.conversation.recepient_image.url : ""