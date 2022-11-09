class ParkingSlot < ApplicationRecord
  scope :available_slots, -> { where(availability: true) }

  has_one_attached :image, dependent: :destroy
  has_one :swapper_host_connection, dependent: :destroy
  belongs_to :user, class_name: "User", foreign_key: :user_id


  validates :longitude, :latitude, :address, presence: :true

  acts_as_mappable :default_units => :kms,
  :default_formula => :sphere,
  :distance_field_name => :distance,
  :lat_column_name => :latitude,
  :lng_column_name => :longitude

end
