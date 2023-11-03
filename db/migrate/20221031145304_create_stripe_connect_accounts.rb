class CreateStripeConnectAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :stripe_connect_accounts do |t|
      t.string :account_id
      t.string :account_country
      t.string :account_type
      t.string :login_account_link
      t.string :external_links
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
