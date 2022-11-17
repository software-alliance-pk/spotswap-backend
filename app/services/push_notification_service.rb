class PushNotificationService
  require 'fcm'
  def self.fcm_push_notification(connection)
    data = {
       swapper: connection.swapper,
       host: connection.host,
       parking_slot: connection.parking_slot, 
       swapper_host_connection_id: connection.id,
       confirmed_screen: connection.confirmed_screen,
       car_model_name: connection.swapper&.car_detail&.car_model&.title,
       user_image: connection.swapper.image.attached? ? connection.swapper.image.url : "",
       car_image: connection.swapper.car_detail&.photos&.attached? ? connection.swapper.car_detail.photos[0].url : "",
       parking_slot_image: connection.parking_slot.image.attached? ? connection.parking_slot.image.url : "",
       body: "Swapper #{connection.swapper.name} and Host #{connection.host.name} has been connected."
      }
      
    fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
    options = { priority: 'high',
          data: { data: data, notification_type: "connection_created" },
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