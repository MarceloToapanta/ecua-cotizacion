# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170410094509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "ruc"
    t.string   "direcction"
    t.string   "sector"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "doctor_name"
    t.string   "doctor_email"
    t.string   "billing_name"
    t.string   "billing_email"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id",       null: false
    t.string   "description"
  end

  create_table "exam_updates", force: :cascade do |t|
    t.string   "authorization"
    t.text     "description"
    t.datetime "date_modification"
    t.integer  "exam_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "exams", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.boolean  "activated"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.decimal  "province_value"
    t.decimal  "m_units_value"
    t.decimal  "city_value"
  end

  create_table "quotation_items", force: :cascade do |t|
    t.integer  "quotation_id"
    t.integer  "exam_id"
    t.decimal  "city_unit"
    t.decimal  "province_unit"
    t.decimal  "m_units_unit"
    t.string   "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.datetime "date"
    t.string   "description"
    t.integer  "user_appoved_id"
    t.datetime "date_approved"
    t.boolean  "approved"
    t.boolean  "published"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "company_id",      null: false
    t.string   "pdf"
    t.integer  "exam_id"
    t.datetime "validity"
    t.integer  "total_users"
    t.boolean  "provinces"
    t.boolean  "medical_center"
    t.boolean  "mobile_units"
    t.decimal  "city_total"
    t.decimal  "province_total"
    t.decimal  "m_units_total"
    t.boolean  "rejected"
    t.integer  "exam_number"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "rol"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
