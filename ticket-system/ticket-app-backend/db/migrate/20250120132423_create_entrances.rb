class CreateEntrances < ActiveRecord::Migration[8.0]
  def change
    create_table :entrances do |t|
      t.string :name
      t.references :venue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
