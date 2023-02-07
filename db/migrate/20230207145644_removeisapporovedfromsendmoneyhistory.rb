class Removeisapporovedfromsendmoneyhistory < ActiveRecord::Migration[6.1]
  def change
    remove_column :send_money_histories, :is_approved, :boolean
    add_column :send_money_histories, :transfer_money_status, :string, default: ""
  end
end
