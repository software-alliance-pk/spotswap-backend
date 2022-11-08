class ParkingSlot < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  validates :longitude, :latitude, :address, presence: :true

  acts_as_mappable :default_units => :kms,
  :default_formula => :sphere,
  :distance_field_name => :distance,
  :lat_column_name => :latitude,
  :lng_column_name => :longitude

end
