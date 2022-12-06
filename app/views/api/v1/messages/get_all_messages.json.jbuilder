json.messages @messages do |message|
  json.partial! 'shared/message_details', message: message
end
json.user_type @user_type
json.sender_online_status @conversation.sender.is_online
json.recepient_online_status @conversation.recepient.is_online