class PaypalPartnerAccount < ApplicationRecord
  belongs_to :user
  enum payment_type: [:credit_card, :paypal, :wallet]
end
