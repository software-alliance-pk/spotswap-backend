class ParkingSlot < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  validates :longitude, :latitude, :address, presence: :true
end
