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

ActiveRecord::Schema[8.0].define(version: 2025_03_11_044226) do
  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "entities", force: :cascade do |t|
    t.string "entity_name", null: false
    t.string "entity_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type"], name: "index_entities_on_entity_type", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "source_wallet_id"
    t.integer "target_wallet_id"
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.datetime "transaction_date_time", null: false
    t.string "transaction_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_wallet_id", "transaction_date_time"], name: "idx_on_source_wallet_id_transaction_date_time_75ef888a81"
    t.index ["source_wallet_id"], name: "index_transactions_on_source_wallet_id"
    t.index ["target_wallet_id", "transaction_date_time"], name: "idx_on_target_wallet_id_transaction_date_time_0300e67f8c"
    t.index ["target_wallet_id"], name: "index_transactions_on_target_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "entity_id", null: false
    t.decimal "balance", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "entity_id"], name: "index_wallets_on_account_id_and_entity_id", unique: true
    t.index ["account_id"], name: "index_wallets_on_account_id"
    t.index ["entity_id"], name: "index_wallets_on_entity_id"
  end

  add_foreign_key "transactions", "wallets", column: "source_wallet_id"
  add_foreign_key "transactions", "wallets", column: "target_wallet_id"
  add_foreign_key "wallets", "accounts", on_delete: :cascade
  add_foreign_key "wallets", "entities", on_delete: :cascade
end
