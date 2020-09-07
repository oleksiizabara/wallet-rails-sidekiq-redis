# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_21_070102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "family_wallet_settings", force: :cascade do |t|
    t.integer "family_id"
    t.json "user_settings", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "wallet_id"
    t.integer "from_id"
    t.string "message"
    t.boolean "is_confirmed", default: false
    t.boolean "is_declined"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_plans", force: :cascade do |t|
    t.integer "from"
    t.integer "to"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.integer "start_capital", default: 1000000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_wallet_transactions", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wallet_transaction_id", null: false
  end

  create_table "users_wallets", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wallet_id", null: false
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.integer "transaction_type", default: 0
    t.integer "status", default: 0
    t.integer "transaction_plan_id"
    t.integer "tax"
    t.string "currency_id", default: "USD"
    t.integer "transfered_money"
    t.boolean "tax_paid_by_the_recipient", default: false
    t.integer "initiator_id"
    t.integer "wallet_from_id"
    t.integer "wallet_to_id"
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallet_transactions_wallets", id: false, force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.bigint "wallet_transaction_id", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.string "type"
    t.string "currency_id", default: "USD"
    t.integer "capital", default: 0
    t.integer "admin_id"
    t.boolean "is_private", default: true
    t.string "description"
    t.string "encrypted_pin"
    t.string "identity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
