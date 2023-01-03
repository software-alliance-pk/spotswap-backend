class AddEmailToPaypalAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :paypal_partner_accounts, :email, :string
  end
end
