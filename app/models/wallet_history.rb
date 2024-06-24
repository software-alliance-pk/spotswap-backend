class WalletHistory < ApplicationRecord
  enum transaction_type: [:debited, :credited]
  enum top_up_description: [:bank_transfer, :spot_swap, :withdraw]
  belongs_to :user
end
