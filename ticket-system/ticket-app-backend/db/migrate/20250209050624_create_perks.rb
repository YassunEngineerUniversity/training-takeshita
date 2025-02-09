class CreatePerks < ActiveRecord::Migration[8.0]
  def change
    create_table :perks do |t|
      t.string :name
      t.boolean :active
      t.datetime :valid_from
      t.datetime :valid_until

      t.timestamps
    end
  end
end
