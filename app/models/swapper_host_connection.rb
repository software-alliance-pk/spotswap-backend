class SwapperHostConnection < ApplicationRecord
  belongs_to :swapper, class_name: "User", foreign_key: :user_id
  belongs_to :host, class_name: "User", foreign_key: :host_id

  belongs_to :parking_slot
  after_create :push_notification

  def push_notification
    PushNotificationService.fcm_push_notification(self)
	end
end
