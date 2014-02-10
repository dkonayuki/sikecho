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

ActiveRecord::Schema.define(version: 20140210100243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: true do |t|
    t.string   "type"
    t.string   "path"
    t.string   "name"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  create_table "faculties", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "university_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties_subjects", force: true do |t|
    t.integer "subject_id"
    t.integer "faculty_id"
  end

  create_table "notes", force: true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes_subjects", force: true do |t|
    t.integer "note_id"
    t.integer "subject_id"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "credit"
    t.integer  "time"
    t.string   "time_name"
    t.integer  "day"
    t.string   "day_name"
    t.string   "place"
    t.integer  "semester"
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

end
