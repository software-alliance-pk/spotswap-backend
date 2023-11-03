class UserCarBrand < ApplicationRecord
  belongs_to :car_detail
  belongs_to :car_brand
end
