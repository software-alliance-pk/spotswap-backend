class AddTopCreatedToUserReferralCodeRecord < ActiveRecord::Migration[6.1]
  def change
    add_column :user_referral_code_records, :is_top_up_created, :boolean, default: false
  end
end
