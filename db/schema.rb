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

ActiveRecord::Schema.define(version: 2022_10_17_150443) do

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
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
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
    t.index ["user_id"], name: "index_car_details_on_user_id"
  end

  create_table "car_models", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "car_brand_id", null: false
    t.index ["car_brand_id"], name: "index_car_models_on_car_brand_id"
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mobile_devices", force: :cascade do |t|
    t.string "mobile_device_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mobile_devices_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "permalink"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "quick_chats", force: :cascade do |t|
    t.text "message"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_quick_chats_on_user_id"
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
    t.bigint "user_id", null: false
    t.bigint "support_conversation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "read_status", default: false
    t.index ["support_conversation_id"], name: "index_support_messages_on_support_conversation_id"
    t.index ["user_id"], name: "index_support_messages_on_user_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "ticket_number"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_supports_on_user_id"
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
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "car_details", "users"
  add_foreign_key "car_models", "car_brands"
  add_foreign_key "mobile_devices", "users"
  add_foreign_key "quick_chats", "users"
  add_foreign_key "support_conversations", "supports"
  add_foreign_key "support_messages", "support_conversations"
  add_foreign_key "support_messages", "users"
  add_foreign_key "supports", "users"
  add_foreign_key "user_car_brands", "car_brands"
  add_foreign_key "user_car_brands", "car_details"
  add_foreign_key "user_car_models", "car_details"
  add_foreign_key "user_car_models", "car_models"
end
