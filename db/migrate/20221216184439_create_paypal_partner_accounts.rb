class CreatePaypalPartnerAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :paypal_partner_account do |t|
      t.string :account_id
      t.string :account_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
