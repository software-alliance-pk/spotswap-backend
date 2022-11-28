class CarDetail < ApplicationRecord
  belongs_to :user
  
  has_one :user_car_model, dependent: :destroy
  has_one :user_car_brand, dependent: :destroy
  has_one :car_brand, through: :user_car_brand
  has_one :car_model, through: :user_car_model
  
  has_many_attached :photos, dependent: :destroy
  
  validates :length, :color, presence: true
end
