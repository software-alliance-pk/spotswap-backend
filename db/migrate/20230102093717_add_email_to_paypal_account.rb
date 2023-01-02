class AddEmailToPaypalAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :paypal_partner_account, :email, :string
  end
end
