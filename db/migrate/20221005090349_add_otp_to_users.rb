class AddOtpToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp, :integer
    add_column :users, :otp_expiry, :datetime
  end
end
