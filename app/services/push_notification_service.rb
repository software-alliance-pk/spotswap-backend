class PushNotificationService
  require 'fcm'
  def self.fcm_push_notification(connection, finder)
    data = {connection: connection, body: "Swapper #{connection.user.name} and Host #{finder.name} has been connected.", user: connection.user, parking_slot: connection.parking_slot, finder: finder, finder_car_model: finder.car_detail.car_model}
    fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
    options = { priority: 'high',
          data: { data: data },
          notification: {
          body: data[:body],
          sound: 'default'
          }
          }
          
    registration_ids = connection.parking_slot.user.mobile_devices.pluck(:mobile_device_token)
    registration_ids.each_slice(20) do |registration_id|
      response = fcm_client.send(registration_id, options)
     puts response
    end
  end
end