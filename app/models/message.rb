class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  has_one_attached :image, dependent: :destroy

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
