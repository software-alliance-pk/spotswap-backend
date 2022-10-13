class Support < ApplicationRecord
  has_one :support_conversations, dependent: :destroy
  belongs_to :user
  has_one_attached :image, dependent: :destroy
  enum status: [:pending, :complete]
end
