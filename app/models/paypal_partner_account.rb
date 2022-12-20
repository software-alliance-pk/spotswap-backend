class PaypalPartnerAccount < ApplicationRecord
  belongs_to :user
  validates :account_id, presence: true
  validates :account_type, presence: true
end
