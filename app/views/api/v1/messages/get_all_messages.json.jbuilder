json.messages @messages do |message|
  json.partial! 'shared/message_details', message: message
end
json.user_type @user_type
json.sender_id @conversation.sender.id
json.sender_online_status @conversation.sender.is_online
json.recipient_id @conversation.recepient.id
json.recipient_online_status @conversation.recepient.is_online