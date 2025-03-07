class CreatePerformances < ActiveRecord::Migration[8.0]
  def change
    create_table :performances do |t|
      t.string :name
      t.references :promoter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
