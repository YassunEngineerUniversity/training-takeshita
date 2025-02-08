class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :ticket_type, null: false, foreign_key: true
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
