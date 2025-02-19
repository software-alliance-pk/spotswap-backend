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

  def self.notify_swapper_on_slot_transfer(connection)
    data = {
      host: connection.host,
      car_model_name: connection.host&.car_detail&.car_model&.title,
      user_image: connection.host&.image&.attached? ? connection.host.image.url : "",
      car_image: connection.host&.car_detail&.photos&.attached? ? connection.host.car_detail.photos[0].url : "",
      parking_slot_image: connection.parking_slot&.image&.attached? ? connection.parking_slot.image.url : "",
      user_type: "Host",
      swapper_payment_type: connection&.swapper&.default_payment&.payment_type,
      body: "#{connection.host.name} wants to transfer his parking slot.",
      amount: connection.parking_slot&.amount,
      fees: connection.parking_slot&.fees
     }
   fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
   options = { priority: 'high',
         data: { data: data, notification_type: "transfer_parking_slot" },
         notification: {
         body: data[:body],
         sound: 'default'
         }
       }
   registration_id = connection&.swapper&.mobile_device&.mobile_device_token
   if registration_id.present?
     response = fcm_client.send(registration_id, options)
     puts response
     return response
   else
     puts "registration id is missing."
   end
  end

  def self.notify_host_on_cancel_request(swapper)
    data = {
      swapper: swapper,
      car_model_name: swapper&.car_detail&.car_model&.title,
      user_image: swapper&.image&.attached? ? swapper.image.url : "",
      car_image: swapper&.car_detail&.photos&.attached? ? swapper.car_detail.photos[0].url : "",
      parking_slot_image: swapper&.parking_slot&.image&.attached? ? swapper&.parking_slot.image.url : "",
      parking_slot_id: swapper&.parking_slot&.id,
      connection_id: swapper&.swapper_host_connection&.id,
      user_type: "Swapper",
      body: "Request has been cancelled by Swapper."
     }   
   fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
   options = { priority: 'high',
         data: { data: data, notification_type: "cancel_connection" },
         notification: {
         body: data[:body],
         sound: 'default'
         }
       }
   registration_id = swapper&.swapper_host_connection&.host&.mobile_device&.mobile_device_token
   if registration_id.present?
     response = fcm_client.send(registration_id, options)
     puts response
     return response
   else
     puts "registration id is missing."
   end
  end

  def self.notify_swapper_for_confirm_arrival(swapper)
    data = {
      swapper: swapper,
      connection_id: swapper&.swapper_host_connection&.id,
      body: "Host is issuing a Confirm Arrival, are you still interested in the spot?."
     }   
   fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
   options = { priority: 'high',
         data: { data: data, notification_type: "confirm_arrival" },
         notification: {
         body: data[:body],
         sound: 'default'
         }
       }
   registration_id = swapper&.mobile_device&.mobile_device_token
   if registration_id.present?
     response = fcm_client.send(registration_id, options)
     puts response
     return response
   else
     puts "registration id is missing."
   end
  end

  def self.notify_host_swapper_is_still_interested(connection)
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
       body: "Swapper #{connection.swapper.name} is still interested in your Parking Slot."
     }   
   fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
   options = { priority: 'high',
         data: { data: data, notification_type: "still_interested" },
         notification: {
         body: data[:body],
         sound: 'default'
         }
       }
   registration_id = connection.host&.mobile_device&.mobile_device_token
   if registration_id.present?
     response = fcm_client.send(registration_id, options)
     return response
   else
     puts "registration id is missing."
   end
  end

  def self.notify_host_payment_has_been_sent_from_swapper(connection, amount, fees)
    data = {
       swapper: connection.swapper,
       parking_slot: connection.parking_slot,
       swapper_host_connection_id: connection.id,
       car_model_name: connection.swapper&.car_detail&.car_model&.title,
       user_image: connection.swapper.image.attached? ? connection.swapper.image.url : "",
       car_image: connection.swapper.car_detail&.photos&.attached? ? connection.swapper.car_detail.photos[0].url : "",
       parking_slot_image: connection.parking_slot.image.attached? ? connection.parking_slot.image.url : "",
       connection_date_time: connection.created_at,
       connection_location: connection.parking_slot.address,
       swapper_fee: amount,
       spot_swap_fee: fees,
       body: "Swapper #{connection.swapper.name} has been sent payment of $#{amount}.00"
     }   
   fcm_client = FCM.new("AAAAlr4iktw:APA91bF55dfM-lYWPqi-dHMnWGvrwQwRMAEJZD6Hu2P1mEdX8sHBcsVzLx3goF2E8ArNLw9EwvaRzlUGd5YDHCY9WOiu0mtP4jR8XXD2aH-5ItgZ12eY90NYxrNuisHjm3mIx8lsMFAo") # set your FCM_SERVER_KEY
   options = { priority: 'high',
         data: { data: data, notification_type: "payment_received" },
         notification: {
         body: data[:body],
         sound: 'default'
         }
       }
   registration_id = connection.host&.mobile_device&.mobile_device_token
   if registration_id.present?
     response = fcm_client.send(registration_id, options)
     return response
     puts response
   else
     puts "registration id is missing."
   end
  end
end
