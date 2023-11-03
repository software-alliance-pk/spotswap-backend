class AddPaypalAccountIdToDefaultPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :default_payments, :paypal_account_id, :integer
  end
end
