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

ActiveRecord::Schema[7.2].define(version: 2022_10_17_135842) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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

  create_table "additional_info", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference"
    t.string "fullname", limit: 128
    t.string "email", limit: 128
    t.json "answers"
    t.datetime "transferred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "application_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "expires_at"
    t.bigint "unaccompanied_minor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "magic_link"
    t.index ["magic_link"], name: "index_application_tokens_on_magic_link"
    t.index ["unaccompanied_minor_id"], name: "index_application_tokens_on_unaccompanied_minor_id"
  end

  create_table "expressions_of_interest", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference"
    t.string "fullname", limit: 128
    t.string "email", limit: 128
    t.json "answers"
    t.datetime "transferred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_expressions_of_interest_on_reference", unique: true
  end

  create_table "individual_expressions_of_interest", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference"
    t.string "fullname", limit: 128
    t.string "email", limit: 128
    t.json "answers"
    t.datetime "transferred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_individual_expressions_of_interest_on_reference", unique: true
  end

  create_table "organisation_expressions_of_interest", force: :cascade do |t|
    t.string "reference"
    t.string "fullname", limit: 128
    t.string "email", limit: 128
    t.json "answers"
    t.datetime "transferred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_organisation_expressions_of_interest_on_reference", unique: true
  end

  create_table "unaccompanied_minors", force: :cascade do |t|
    t.string "reference"
    t.string "fullname", limit: 128
    t.string "email", limit: 128
    t.json "answers"
    t.datetime "transferred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_cancelled", default: false
    t.index ["reference"], name: "index_unaccompanied_minors_on_reference", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "application_tokens", "unaccompanied_minors"
end
