class UserCarModel < ApplicationRecord
  belongs_to :car_detail
  belongs_to :car_model
end
