class AddRecordedAtToStatistics < ActiveRecord::Migration[6.0]
  def change
    change_table :statistics do |t|
      t.column :recorded_at, :datetime
    end
  end
end
