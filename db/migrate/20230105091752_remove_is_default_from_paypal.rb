class RemoveIsDefaultFromPaypal < ActiveRecord::Migration[6.1]
  def change
    remove_column :paypal_partner_accounts, :is_default, :boolean
    add_column :paypal_partner_accounts, :is_default, :boolean, default: false
  end
end
