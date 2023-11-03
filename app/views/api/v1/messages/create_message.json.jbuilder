json.message do
  json.partial! 'shared/message_details', message: @message
end