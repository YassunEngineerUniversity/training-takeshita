class CreateTicketTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_types do |t|
      t.string :name
      t.references :event, null: false, foreign_key: true
      t.references :entrance, null: false, foreign_key: true

      t.timestamps
    end
  end
end
