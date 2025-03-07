class CreatePerkUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :perk_usages do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :perk, null: false, foreign_key: true
      t.datetime :used_at

      t.timestamps
    end
  end
end
