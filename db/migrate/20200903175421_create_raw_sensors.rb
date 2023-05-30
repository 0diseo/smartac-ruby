class CreateRawSensors < ActiveRecord::Migration[6.0]
  def change
    create_table :raw_sensors do |t|
      t.text :json_data
      t.boolean :processed
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
