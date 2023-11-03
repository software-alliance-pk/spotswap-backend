class CreateUserReferralCodeRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :user_referral_code_records do |t|
      t.integer :referrer_id
      t.string :referrer_code
      t.string :user_code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
