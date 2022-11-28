class DefaultPayment < ApplicationRecord
  belongs_to :card_detail
  belongs_to :user
end
