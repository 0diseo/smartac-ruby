class AddValuesToStatistics < ActiveRecord::Migration[6.0]
  def change
    change_table :statistics do |t|
      t.remove :name
      t.remove :value
      t.float :temperature
      t.float :humidity
      t.float :co_level
      t.string :health
      t.references :raw_sensor
    end
  end
end
