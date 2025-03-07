class CreateTicketAgencies < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_agencies do |t|
      t.string :name
      t.string :api_key

      t.timestamps
    end
  end
end
