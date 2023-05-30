class DropRawReadingsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table(:raw_readings)
  end
end
