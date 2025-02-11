class CreateTicketTransferHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_transfer_histories do |t|
      t.references :ticket, null: false, foreign_key: true
      t.integer :from_reservation_id
      t.integer :to_reservation_id
      t.datetime :transferred_at

      t.timestamps
    end
  end
end
