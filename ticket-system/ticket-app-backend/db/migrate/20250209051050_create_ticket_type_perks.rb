class CreateTicketTypePerks < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_type_perks do |t|
      t.references :ticket_type, null: false, foreign_key: true
      t.references :perk, null: false, foreign_key: true

      t.timestamps
    end
  end
end
