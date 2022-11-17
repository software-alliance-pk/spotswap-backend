class UserReferralCodeRecord < ApplicationRecord
  belongs_to :user
  validates :referrer_id, :referrer_code, :user_code, presence: true
end
