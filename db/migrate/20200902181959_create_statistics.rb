class CreateStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :statistics do |t|
      t.string :name
      t.string :value
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
