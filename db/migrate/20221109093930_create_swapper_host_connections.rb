class CreateSwapperHostConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :swapper_host_connections do |t|
      t.boolean :connection_screen, default: false
      t.boolean :is_cancelled_by_swapper, default: false
      t.boolean :confirmed_screen, default: false
      t.references :user, null: false, foreign_key: true
      t.references :parking_slot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
