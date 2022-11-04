class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recepient, class_name: "User", foreign_key: :recepient_id

  delegate :name, to: :sender, prefix: :sender
  delegate :name, to: :recepient, prefix: :recepient
  delegate :image, to: :sender, prefix: :sender
  delegate :image, to: :recepient, prefix: :recepient
end
