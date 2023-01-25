class AddIsApprovedToSendMoneyHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :send_money_histories, :is_approved, :boolean, default: false
  end
end
