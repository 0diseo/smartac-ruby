class RenameRawSensorsToRawReadings < ActiveRecord::Migration[6.0]
  def change
    rename_table :raw_sensors, :raw_readings

    change_table :readings do |t|
      t.rename :raw_sensor_id, :raw_reading_id
    end
  end
end
