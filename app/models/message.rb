class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
