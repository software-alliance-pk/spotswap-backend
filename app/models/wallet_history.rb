class WalletHistory < ApplicationRecord
  enum transaction_type: [:debited, :credited]
  enum top_up_description: [:bank_transfer, :spot_swap]
  belongs_to :user
end
