class UserReferralCodeRecord < ApplicationRecord
  belongs_to :user
  validates :referrer_id, :referrer_code, :user_code, presence: true

  after_commit :check_user_eligibility_for_top_up

  def check_user_eligibility_for_top_up
    @transfer_response = nil
    if UserReferralCodeRecord.where(referrer_id: self.referrer_id).count == 10
      @transfer_response = StripeTransferService.new.transfer_amount_of_top_up_to_customer_connect_account(10, User.find_by_id(self.referrer_id).stripe_connect_account.account_id)
    end
    return @transfer_response
  end
end
