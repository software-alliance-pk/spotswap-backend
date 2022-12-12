class CardDetail < ApplicationRecord
  belongs_to :user
  has_one :default_payment, dependent: :destroy

  enum payment_type: [:credit_card, :paypal, :wallet]
end