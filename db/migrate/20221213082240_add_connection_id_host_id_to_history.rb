class AddConnectionIdHostIdToHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :histories, :connection_id, :integer
    add_column :histories, :host_id, :integer, null: false
  end
end
