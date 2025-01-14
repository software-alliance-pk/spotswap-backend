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

ActiveRecord::Schema.define(version: 2024_06_13_135756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.integer "category", default: 0
    t.string "contact"
    t.string "location"
    t.string "otp"
    t.string "status", default: "0"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "blocked_user_details", force: :cascade do |t|
    t.integer "blocked_user_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_blocked_user_details_on_user_id"
  end

  create_table "car_brands", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "car_details", force: :cascade do |t|
    t.integer "length"
    t.string "color"
    t.string "plate_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "height"
    t.integer "width"
    t.boolean "is_show", default: true
    t.index ["user_id"], name: "index_car_details_on_user_id"
  end

  create_table "car_models", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "car_brand_id", null: false
    t.string "color"
    t.integer "length"
    t.integer "width"
    t.integer "height"
    t.integer "released"
    t.string "plate_number"
    t.index ["car_brand_id"], name: "index_car_models_on_car_brand_id"
  end

  create_table "card_details", force: :cascade do |t|
    t.string "card_id"
    t.integer "exp_month"
    t.integer "exp_year"
    t.string "brand"
    t.string "country"
    t.string "fingerprint"
    t.string "last_digit"
    t.string "name"
    t.boolean "is_default", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.integer "payment_type"
    t.index ["user_id"], name: "index_card_details_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "recepient_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_blocked", default: false
    t.integer "user_id", null: false
  end

  create_table "default_payments", force: :cascade do |t|
    t.string "payment_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "card_detail_id"
    t.integer "paypal_account_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "histories", force: :cascade do |t|
    t.datetime "connection_date_time"
    t.string "connection_location"
    t.integer "swapper_fee"
    t.integer "spotswap_fee"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "transaction_type"
    t.integer "total_fee"
    t.string "type"
    t.integer "swapper_id", null: false
    t.integer "connection_id"
    t.integer "host_id", null: false
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "body"
    t.boolean "read_status", default: false
    t.bigint "conversation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "mobile_devices", force: :cascade do |t|
    t.string "mobile_device_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mobile_devices_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "subject"
    t.string "body"
    t.boolean "is_clear", default: false
    t.string "notify_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "swapper_id"
    t.integer "host_id"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "permalink"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "parking_slots", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "longitude"
    t.float "latitude"
    t.string "address"
    t.boolean "availability", default: false
    t.bigint "user_id", null: false
    t.integer "amount"
    t.integer "fees"
    t.index ["user_id"], name: "index_parking_slots_on_user_id"
  end

  create_table "paypal_partner_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "payment_type"
    t.string "account_id"
    t.string "account_type"
    t.string "email"
    t.boolean "is_default", default: false
    t.index ["user_id"], name: "index_paypal_partner_accounts_on_user_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "quick_chats", force: :cascade do |t|
    t.text "message"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_quick_chats_on_user_id"
  end

  create_table "revenues", force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "send_money_histories", force: :cascade do |t|
    t.decimal "amount"
    t.integer "admin_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transfer_money_status", default: ""
    t.index ["user_id"], name: "index_send_money_histories_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "csv_download_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stripe_connect_accounts", force: :cascade do |t|
    t.string "account_id"
    t.string "account_country"
    t.string "account_type"
    t.string "login_account_link"
    t.string "external_links"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_stripe_connect_accounts_on_user_id"
  end

  create_table "support_conversations", force: :cascade do |t|
    t.bigint "support_id", null: false
    t.integer "recipient_id", null: false
    t.integer "sender_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["support_id"], name: "index_support_conversations_on_support_id"
  end

  create_table "support_messages", force: :cascade do |t|
    t.string "body"
    t.bigint "support_conversation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "read_status", default: false
    t.integer "sender_id"
    t.string "type"
    t.bigint "user_id"
    t.index ["support_conversation_id"], name: "index_support_messages_on_support_conversation_id"
    t.index ["user_id"], name: "index_support_messages_on_user_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "ticket_number"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "swapper_host_connections", force: :cascade do |t|
    t.boolean "connection_screen", default: false
    t.boolean "is_cancelled_by_swapper", default: false
    t.boolean "confirmed_screen", default: false
    t.bigint "user_id", null: false
    t.bigint "parking_slot_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "host_id", null: false
    t.index ["parking_slot_id"], name: "index_swapper_host_connections_on_parking_slot_id"
    t.index ["user_id"], name: "index_swapper_host_connections_on_user_id"
  end

  create_table "user_car_brands", force: :cascade do |t|
    t.bigint "car_detail_id", null: false
    t.bigint "car_brand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["car_brand_id"], name: "index_user_car_brands_on_car_brand_id"
    t.index ["car_detail_id"], name: "index_user_car_brands_on_car_detail_id"
  end

  create_table "user_car_models", force: :cascade do |t|
    t.bigint "car_detail_id", null: false
    t.bigint "car_model_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["car_detail_id"], name: "index_user_car_models_on_car_detail_id"
    t.index ["car_model_id"], name: "index_user_car_models_on_car_model_id"
  end

  create_table "user_referral_code_records", force: :cascade do |t|
    t.integer "referrer_id"
    t.string "referrer_code"
    t.string "user_code"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_top_up_created", default: false
    t.index ["user_id"], name: "index_user_referral_code_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "contact"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "profile_complete", default: false
    t.string "profile_type"
    t.integer "otp"
    t.datetime "otp_expiry"
    t.boolean "is_info_complete", default: false
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "stripe_customer_id"
    t.string "country_code"
    t.string "referral_code"
    t.string "stripe_connect_id"
    t.boolean "is_online", default: false
    t.integer "referrer_id"
    t.boolean "is_disabled", default: false
    t.decimal "amount_transfer"
    t.string "transfer_from"
    t.string "status", default: "0"
  end

  create_table "wallet_histories", force: :cascade do |t|
    t.integer "top_up_description"
    t.string "amount"
    t.integer "transaction_type"
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_wallet_histories_on_user_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_default", default: false
    t.integer "payment_type"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", on_delete: :cascade
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", on_delete: :cascade
  add_foreign_key "blocked_user_details", "users", on_delete: :cascade
  add_foreign_key "car_details", "users", on_delete: :cascade
  add_foreign_key "car_models", "car_brands", on_delete: :cascade
  add_foreign_key "card_details", "users", on_delete: :cascade
  add_foreign_key "histories", "users", on_delete: :cascade
  add_foreign_key "messages", "conversations", on_delete: :cascade
  add_foreign_key "messages", "users", on_delete: :cascade
  add_foreign_key "mobile_devices", "users", on_delete: :cascade
  add_foreign_key "notifications", "users", on_delete: :cascade
  add_foreign_key "parking_slots", "users", on_delete: :cascade
  add_foreign_key "paypal_partner_accounts", "users", on_delete: :cascade
  add_foreign_key "quick_chats", "users", on_delete: :cascade
  add_foreign_key "send_money_histories", "users", on_delete: :cascade
  add_foreign_key "stripe_connect_accounts", "users", on_delete: :cascade
  add_foreign_key "support_conversations", "supports", on_delete: :cascade
  add_foreign_key "support_messages", "support_conversations", on_delete: :cascade
  add_foreign_key "support_messages", "users", on_delete: :cascade
  add_foreign_key "supports", "users", on_delete: :cascade
  add_foreign_key "swapper_host_connections", "parking_slots", on_delete: :cascade
  add_foreign_key "swapper_host_connections", "users", on_delete: :cascade
  add_foreign_key "user_car_brands", "car_brands", on_delete: :cascade
  add_foreign_key "user_car_brands", "car_details", on_delete: :cascade
  add_foreign_key "user_car_models", "car_details", on_delete: :cascade
  add_foreign_key "user_car_models", "car_models", on_delete: :cascade
  add_foreign_key "user_referral_code_records", "users", on_delete: :cascade
  add_foreign_key "wallet_histories", "users", on_delete: :cascade
  add_foreign_key "wallets", "users", on_delete: :cascade
end
