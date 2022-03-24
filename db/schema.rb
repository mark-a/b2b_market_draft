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

ActiveRecord::Schema[7.0].define(version: 2022_02_18_114307) do
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.datetime "published_at", precision: nil
    t.string "announcement_type"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies_members", id: false, force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "member_id", null: false
  end

  create_table "company_profiles", force: :cascade do |t|
    t.string "company_name"
    t.string "legal_form"
    t.text "address"
    t.string "phone"
    t.string "contact_email"
    t.string "contact_web"
    t.text "about_us"
    t.text "bg_color_hex"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_profiles_on_company_id"
  end

  create_table "licences", force: :cascade do |t|
    t.string "key"
    t.datetime "activated_on", precision: nil
    t.integer "max_accounts"
    t.integer "valid_days"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_licences_on_company_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "announcements_last_read_at"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_members_on_unlock_token", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.integer "recipient_id", null: false
    t.string "type", null: false
    t.text "params"
    t.datetime "read_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "search_categories", force: :cascade do |t|
    t.string "title"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_search_categories_on_parent_id"
  end

  create_table "search_category_memberships", force: :cascade do |t|
    t.integer "category_id"
    t.integer "criterium_group_id"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_search_category_memberships_on_category_id"
    t.index ["criterium_group_id"], name: "index_search_category_memberships_on_criterium_group_id"
  end

  create_table "search_criteria", force: :cascade do |t|
    t.integer "category_id"
    t.string "name", limit: 64
    t.string "valuetype", limit: 64
    t.integer "divisor"
    t.integer "min"
    t.integer "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_search_criteria_on_category_id"
  end

  create_table "search_criterium_group_memberships", force: :cascade do |t|
    t.integer "criterium_id"
    t.integer "criterium_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterium_group_id"], name: "group_membership"
    t.index ["criterium_id"], name: "index_search_criterium_group_memberships_on_criterium_id"
  end

  create_table "search_criterium_groups", force: :cascade do |t|
    t.string "title", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_criterium_values", force: :cascade do |t|
    t.integer "criterium_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterium_id"], name: "index_search_criterium_values_on_criterium_id"
  end

  create_table "search_provider_criteria_matchings", force: :cascade do |t|
    t.integer "company_id"
    t.integer "criterium_id"
    t.integer "values_from"
    t.integer "values_to"
    t.integer "criterium_value_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_search_provider_criteria_matchings_on_company_id"
    t.index ["criterium_id"], name: "index_search_provider_criteria_matchings_on_criterium_id"
  end

  create_table "search_purchaser_criteria_matchings", force: :cascade do |t|
    t.integer "company_id"
    t.integer "criterium_id"
    t.integer "values_from"
    t.integer "values_to"
    t.integer "criterium_value_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_search_purchaser_criteria_matchings_on_company_id"
    t.index ["criterium_id"], name: "index_search_purchaser_criteria_matchings_on_criterium_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "search_categories", "search_categories", column: "parent_id"
  add_foreign_key "search_category_memberships", "search_categories", column: "category_id"
  add_foreign_key "search_category_memberships", "search_criterium_groups", column: "criterium_group_id"
  add_foreign_key "search_criteria", "search_categories", column: "category_id"
  add_foreign_key "search_criterium_group_memberships", "search_criteria", column: "criterium_id"
  add_foreign_key "search_criterium_group_memberships", "search_criterium_groups", column: "criterium_group_id"
  add_foreign_key "search_criterium_values", "search_criteria", column: "criterium_id"
  add_foreign_key "search_provider_criteria_matchings", "companies"
  add_foreign_key "search_provider_criteria_matchings", "search_criteria", column: "criterium_id"
  add_foreign_key "search_purchaser_criteria_matchings", "companies"
  add_foreign_key "search_purchaser_criteria_matchings", "search_criteria", column: "criterium_id"
end
