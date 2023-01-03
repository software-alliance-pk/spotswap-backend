class ModifyPaypalTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :paypal_partner_accounts, :account_id, :string
    remove_column :paypal_partner_accounts, :account_type, :string
    add_column :paypal_partner_accounts, :is_default, :boolean, default: true
    add_column :paypal_partner_accounts, :payment_type, :integer
  end
end
