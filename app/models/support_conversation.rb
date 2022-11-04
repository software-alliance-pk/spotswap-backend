class SupportConversation < ApplicationRecord
  belongs_to :support
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "Admin", foreign_key: :recipient_id
  has_many :support_messages, dependent: :destroy

  delegate :name, to: :sender, prefix: :sender
  delegate :full_name, to: :recipient, prefix: :recipient
  delegate :image, to: :sender, prefix: :sender
  delegate :image, to: :recipient, prefix: :recipient
end
