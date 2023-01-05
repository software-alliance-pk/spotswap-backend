class AddEmailToPaypal < ActiveRecord::Migration[6.1]
  def change
    add_column :paypal_partner_accounts, :email, :string, if_not_exists: true
  end
end
