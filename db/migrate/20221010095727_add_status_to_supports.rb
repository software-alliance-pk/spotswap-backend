class AddStatusToSupports < ActiveRecord::Migration[6.1]
  def change
    add_column :supports, :name, :string
    add_column :supports, :status, :integer, default: 0
  end
end
