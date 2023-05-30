class RenameStatisticsToReadings < ActiveRecord::Migration[6.0]
  def change
    rename_table :statistics, :readings
  end
end
