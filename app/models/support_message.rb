class SupportMessage < ApplicationRecord
  belongs_to :user
  belongs_to :support_conversation
  has_one_attached :image, dependent: :destroy
  has_one_attached :file, dependent: :destroy
  validates_presence_of :body

  after_create_commit { SupportMessageBroadcastJob.perform_later(self) }

end
