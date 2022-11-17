class AddHostToSwapperHostConnection < ActiveRecord::Migration[6.1]
  def change
    add_column :swapper_host_connections, :host_id, :integer, null: false
  end
end
