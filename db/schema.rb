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

ActiveRecord::Schema.define(version: 20140321104826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses_subjects", force: true do |t|
    t.integer "subject_id"
    t.integer "course_id"
  end

  create_table "documents", force: true do |t|
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
  end

  create_table "faculties", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "university_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "view"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes_subjects", force: true do |t|
    t.integer "note_id"
    t.integer "subject_id"
  end

  create_table "outlines", force: true do |t|
    t.integer  "number"
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

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "credit"
    t.string   "place"
    t.integer  "semester_id"
    t.integer  "uni_year_id"
    t.integer  "university_id"
    t.integer  "number_of_outlines"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects_teachers", force: true do |t|
    t.integer "subject_id"
    t.integer "teacher_id"
  end

  create_table "subjects_users", force: true do |t|
    t.integer "subject_id"
    t.integer "user_id"
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

  create_table "tags", force: true do |t|
    t.string "name"
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
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.string   "nickname"
    t.integer  "university_id"
    t.integer  "faculty_id"
    t.integer  "course_id"
    t.string   "first_name"
    t.string   "first_name_kana"
    t.string   "first_name_kanji"
    t.string   "last_name"
    t.string   "last_name_kana"
    t.string   "last_name_kanji"
    t.string   "avatar"
    t.date     "dob"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
