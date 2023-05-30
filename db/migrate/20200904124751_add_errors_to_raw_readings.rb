class AddErrorsToRawReadings < ActiveRecord::Migration[6.0]
  def change
    add_column :raw_readings, :process_errors, :text
  end
end
