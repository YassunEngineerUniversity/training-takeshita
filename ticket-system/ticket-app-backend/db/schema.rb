# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_11_072402) do
  create_table "entrances", force: :cascade do |t|
    t.string "name"
    t.integer "venue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_entrances_on_venue_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "performance_id", null: false
    t.integer "venue_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["performance_id"], name: "index_events_on_performance_id"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "performances", force: :cascade do |t|
    t.string "name"
    t.integer "promoter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promoter_id"], name: "index_performances_on_promoter_id"
  end

  create_table "perk_usages", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.integer "perk_id", null: false
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perk_id"], name: "index_perk_usages_on_perk_id"
    t.index ["ticket_id"], name: "index_perk_usages_on_ticket_id"
  end

  create_table "perks", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "valid_from"
    t.datetime "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promoters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "ticket_agency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_agency_id"], name: "index_reservations_on_ticket_agency_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "ticket_agencies", force: :cascade do |t|
    t.string "name"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_transfer_histories", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.integer "from_reservation_id"
    t.integer "to_reservation_id"
    t.datetime "transferred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_transfer_histories_on_ticket_id"
  end

  create_table "ticket_type_perks", force: :cascade do |t|
    t.integer "ticket_type_id", null: false
    t.integer "perk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perk_id"], name: "index_ticket_type_perks_on_perk_id"
    t.index ["ticket_type_id"], name: "index_ticket_type_perks_on_ticket_type_id"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string "name"
    t.integer "event_id", null: false
    t.integer "entrance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entrance_id"], name: "index_ticket_types_on_entrance_id"
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "reservation_id", null: false
    t.integer "user_id", null: false
    t.integer "ticket_type_id", null: false
    t.boolean "used", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_tickets_on_reservation_id"
    t.index ["ticket_type_id"], name: "index_tickets_on_ticket_type_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "entrances", "venues"
  add_foreign_key "events", "performances"
  add_foreign_key "events", "venues"
  add_foreign_key "performances", "promoters"
  add_foreign_key "perk_usages", "perks"
  add_foreign_key "perk_usages", "tickets"
  add_foreign_key "reservations", "ticket_agencies"
  add_foreign_key "reservations", "users"
  add_foreign_key "ticket_transfer_histories", "tickets"
  add_foreign_key "ticket_type_perks", "perks"
  add_foreign_key "ticket_type_perks", "ticket_types"
  add_foreign_key "ticket_types", "entrances"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tickets", "reservations"
  add_foreign_key "tickets", "ticket_types"
  add_foreign_key "tickets", "users"
end
