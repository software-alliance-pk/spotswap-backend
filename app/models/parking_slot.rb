class ParkingSlot < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  validates :description, :image, presence: :true
end
