class PushNotificationService
  require 'fcm'
  def self.fcm_push_notification(connection)
    data = {connection: connection, body: "Swapper #{connection.swapper.name} and Host #{connection.host.name} has been connected.", host: connection.host, parking_slot: connection.parking_slot, swapper: connection.swapper, finder_car_model: connection.swapper&.car_detail&.car_model}
    fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
    options = { priority: 'high',
          data: { data: data },
          notification: {
          body: data[:body],
          sound: 'default'
          }
        }
    registration_id = connection.host&.mobile_device&.mobile_device_token
    if registration_id.present?
      response = fcm_client.send(registration_id, options)
      puts response
    else
      puts "registration id is missing."
    end
  end
end