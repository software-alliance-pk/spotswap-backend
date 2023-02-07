class ModifyStatusFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :status, :integer
    add_column :users, :status, :string, default: "0"
  end
end
