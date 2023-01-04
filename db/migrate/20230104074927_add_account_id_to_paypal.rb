class AddAccountIdToPaypal < ActiveRecord::Migration[6.1]
  def change
    add_column :paypal_partner_accounts, :account_id, :string
    add_column :paypal_partner_accounts, :account_type, :string
  end
end
