class AddContactLocationStatusToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :contact, :string
    add_column :admins, :location, :string
    add_column :admins, :status, :integer, default: 0
  end
end
