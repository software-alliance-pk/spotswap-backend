class CarModel < ApplicationRecord
  belongs_to :car_brand
  has_one_attached :image, dependent: :destroy

  validates :title, :color, :length, :width, :height, :released, presence: true
end
