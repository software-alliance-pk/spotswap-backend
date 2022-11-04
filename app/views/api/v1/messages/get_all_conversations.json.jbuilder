json.conversations @conversations do |conversation|
  json.partial! 'shared/conversation_details', conversation: conversation
end