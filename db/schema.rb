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

ActiveRecord::Schema.define(version: 20131120011723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campus", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "university_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "comments", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: true do |t|
    t.string   "course_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "faculty_id"
  end

  create_table "faculties", force: true do |t|
    t.string   "faculty_name"
    t.string   "website"
    t.integer  "university_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "notes", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "image_path"
    t.string   "pdf_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "subject_id"
  end

  create_table "periods", force: true do |t|
    t.integer  "period"
    t.string   "period_name"
    t.integer  "day"
    t.string   "day_name"
    t.integer  "subject_id"
    t.integer  "year"
    t.integer  "term_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "subjects", force: true do |t|
    t.string   "subject_name"
    t.integer  "course_id"
    t.integer  "teacher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "credit"
    t.integer  "term_id"
    t.integer  "campus_id"
    t.string   "description"
    t.string   "subject_code"
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

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "teachers", force: true do |t|
    t.string   "teacher_name"
    t.string   "teacher_kana_name"
    t.string   "teacher_surname"
    t.string   "teacher_kana_surname"
    t.string   "role"
    t.string   "university_id"
    t.string   "faculty_id"
    t.string   "course_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "terms", force: true do |t|
    t.string   "name"
    t.integer  "start_month"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "universities", force: true do |t|
    t.string   "university_name"
    t.string   "address"
    t.string   "website"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: true do |t|
    t.string   "nickname"
    t.string   "password"
    t.string   "email_address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "course_id"
    t.integer  "university_id"
    t.integer  "faculty_id"
  end

  create_table "users_users", id: false, force: true do |t|
    t.integer "user_a_id", null: false
    t.integer "user_b_id", null: false
  end

end
