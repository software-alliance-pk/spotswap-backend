json.messages @messages do |message|
  json.partial! 'shared/message_details', message: message
end