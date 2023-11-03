json.conversation do
  json.partial! 'shared/conversation_details', conversation: @conversation
end
json.user_type @user_type
json.sender_online_status @conversation.sender.is_online
json.recepient_online_status @conversation.recepient.is_online