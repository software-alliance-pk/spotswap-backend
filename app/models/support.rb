class Support < ApplicationRecord
  has_one :support_conversation, dependent: :destroy
  belongs_to :user
  has_one_attached :image, dependent: :destroy
  enum status: [:pending, :completed]

  validates :description, :name, presence: true
end
