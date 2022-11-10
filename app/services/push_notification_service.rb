class PushNotificationService
  require 'fcm'
  def self.fcm_push_notification(connection)
    message = {connection: connection, user: connection.user, parking_slot: connection.parking_slot}

    fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
    options = { priority: 'high',
          data: { message: message },
          notification: {
          body: message,
          sound: 'default'
          }
          }
    puts options
    registration_ids = connection.parking_slot.user.mobile_devices.pluck(:mobile_device_token)
    # A registration ID looks something like: “dAlDYuaPXes:APA91bFEipxfcckxglzRo8N1SmQHqC6g8SWFATWBN9orkwgvTM57kmlFOUYZAmZKb4XGGOOL9wqeYsZHvG7GEgAopVfVupk_gQ2X5Q4Dmf0Cn77nAT6AEJ5jiAQJgJ_LTpC1s64wYBvC”
    registration_ids.each_slice(20) do |registration_id|
      response = fcm_client.send(registration_id, options)
     puts response
    end
  end
end