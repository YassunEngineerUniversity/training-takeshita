class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket_agency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
