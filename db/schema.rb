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

ActiveRecord::Schema.define(version: 20140917092011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "document_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.integer  "note_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
  end

  create_table "educations", force: true do |t|
    t.integer  "uni_year_id"
    t.integer  "semester_id"
    t.integer  "year"
    t.integer  "university_id"
    t.integer  "faculty_id"
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "current_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations_subjects", force: true do |t|
    t.integer "education_id"
    t.integer "subject_id"
  end

  create_table "faculties", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "university_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "notes", force: true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "view_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes_subjects", force: true do |t|
    t.integer "note_id"
    t.integer "subject_id"
  end

  create_table "outlines", force: true do |t|
    t.integer  "no"
    t.date     "date"
    t.text     "content"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periods", force: true do |t|
    t.integer  "day"
    t.integer  "time"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "read_marks", force: true do |t|
    t.integer  "readable_id"
    t.integer  "user_id",                  null: false
    t.string   "readable_type", limit: 20, null: false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], name: "index_read_marks_on_user_id_and_readable_type_and_readable_id", using: :btree

  create_table "semesters", force: true do |t|
    t.integer  "no"
    t.string   "name"
    t.integer  "uni_year_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "credit"
    t.string   "place"
    t.integer  "semester_id"
    t.integer  "uni_year_id"
    t.integer  "course_id"
    t.integer  "year"
    t.integer  "view_count",           default: 0
    t.integer  "notes_count",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "subjects_teachers", force: true do |t|
    t.integer "subject_id"
    t.integer "teacher_id"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "teachers", force: true do |t|
    t.string   "first_name"
    t.string   "first_name_kana"
    t.string   "first_name_kanji"
    t.string   "last_name"
    t.string   "last_name_kana"
    t.string   "last_name_kanji"
    t.text     "role"
    t.integer  "university_id"
    t.integer  "faculty_id"
    t.string   "lab"
    t.string   "lab_url"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uni_years", force: true do |t|
    t.integer  "no"
    t.string   "name"
    t.integer  "university_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "universities", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codename"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "first_name_kana"
    t.string   "first_name_kanji"
    t.string   "last_name"
    t.string   "last_name_kana"
    t.string   "last_name_kanji"
    t.integer  "gender"
    t.date     "dob"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
