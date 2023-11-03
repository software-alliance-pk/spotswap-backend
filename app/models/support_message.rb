class SupportMessage < ApplicationRecord
  belongs_to :support_conversation
  has_one_attached :image, dependent: :destroy
  has_one_attached :file, dependent: :destroy
  belongs_to :sender, class_name: "User",foreign_key: :sender_id, optional: true

  after_create_commit { SupportMessageBroadcastJob.perform_later(self) }
end
