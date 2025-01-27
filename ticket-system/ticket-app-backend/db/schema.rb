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

ActiveRecord::Schema[8.0].define(version: 2025_01_23_114649) do
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_time"
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

  create_table "promoters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.integer "ticket_agency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_agency_id"], name: "index_reservations_on_ticket_agency_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "ticket_agencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_tickets_on_reservation_id"
    t.index ["ticket_type_id"], name: "index_tickets_on_ticket_type_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin"
    t.string "activation_digest"
    t.boolean "activated"
    t.datetime "activated_at"
    t.string "remember_digest"
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
  add_foreign_key "reservations", "ticket_agencies"
  add_foreign_key "reservations", "users"
  add_foreign_key "ticket_types", "entrances"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tickets", "reservations"
  add_foreign_key "tickets", "ticket_types"
  add_foreign_key "tickets", "users"
end
