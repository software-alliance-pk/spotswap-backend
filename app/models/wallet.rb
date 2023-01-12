class Wallet < ApplicationRecord
  attr_accessor :wallet_amount
  belongs_to :user
  enum payment_type: [:credit_card, :paypal, :wallet]
end
