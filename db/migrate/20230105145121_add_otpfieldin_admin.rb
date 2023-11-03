class AddOtpfieldinAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :otp,:string
  end
end
