# require 'fcm'
# def fcm_push_notification
#     # fcm_client = FCM.new(FCM_SEVER_KEY) # set your FCM_SERVER_KEY
#     # options = { priority: 'high',
#     #             data: { message: message, icon: image },
#     #             notification: { 
#     #             body: message,
#     #             sound: 'default',
#     #             icon: image
#     #             }
#     #           }
#     # registration_ids = ["registration_id1", "registration_id2"] ([Array of registration ids up to 1000])
#     # # A registration ID looks something like: “dAlDYuaPXes:APA91bFEipxfcckxglzRo8N1SmQHqC6g8SWFATWBN9orkwgvTM57kmlFOUYZAmZKb4XGGOOL9wqeYsZHvG7GEgAopVfVupk_gQ2X5Q4Dmf0Cn77nAT6AEJ5jiAQJgJ_LTpC1s64wYBvC”
#     # registration_ids.each_slice(20) do |registration_id|
#     #     response = fcm_client.send(registration_id, options)
#     #     puts response
#     # end
# end