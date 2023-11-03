class AddUserToDefaultPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :default_payments, :user_id, :integer, null: false
  end
end
