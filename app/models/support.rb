class Support < ApplicationRecord
  has_one :support_conversation, dependent: :destroy
  belongs_to :user
  enum status: [:pending, :completed]

  validates :description, :name, presence: true
end
