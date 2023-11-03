class ModifyStatusFromAdmin < ActiveRecord::Migration[6.1]
  def change
    remove_column :admins, :status, :integer
    add_column :admins, :status, :string, default: "0"
  end
end
