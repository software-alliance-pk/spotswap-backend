class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.bigint :csv_download_count, default: 0

      t.timestamps
    end
  end
end
