class PushNotificationService
  require 'fcm'
  def self.fcm_push_notification(connection)
    message = {connection: connection, user: connection.user, parking_slot: connection.parking_slot}

    fcm_client = FCM.new("AAAAyBDcdag:APA91bFtIo0jPppavG5gExCfcRJMsMvnzJTENiBscXdM6P86rOsrVgF1kH-rI9gSYkpcShtvpukhZlR8G9aK9pC7cTw8C0L_dFEMT4thE_KK0g7rPlz7JUCDO1AU3mF2778JnShuUMzs") # set your FCM_SERVER_KEY
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