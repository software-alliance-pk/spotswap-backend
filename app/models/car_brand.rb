class CarBrand < ApplicationRecord
  has_many :car_models, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  
  validates :title, presence: true
end
