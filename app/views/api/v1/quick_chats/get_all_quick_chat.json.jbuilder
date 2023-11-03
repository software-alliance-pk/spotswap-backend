json.chats @quick_chat do |chat|
  json.partial! 'shared/quick_chat_details', quick_chat: chat
end