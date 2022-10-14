class SupportMessage < ApplicationRecord
  belongs_to :user
  belongs_to :support_conversation
  has_one_attached :image, dependent: :destroy
end
