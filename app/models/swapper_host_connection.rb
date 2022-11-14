class SwapperHostConnection < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot
  after_create :push_notification

  def push_notification
    PushNotificationService.fcm_push_notification(self, self.parking_slot.user)
	end
end
