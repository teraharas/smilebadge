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

ActiveRecord::Schema.define(version: 20151126102340) do

  create_table "badgeposts", force: :cascade do |t|
    t.integer  "sent_user_id"
    t.integer  "recept_user_id"
    t.integer  "badge_id"
    t.text     "content"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "badgeposts", ["badge_id"], name: "index_badgeposts_on_badge_id"
  add_index "badgeposts", ["recept_user_id", "created_at"], name: "index_badgeposts_on_recept_user_id_and_created_at"
  add_index "badgeposts", ["recept_user_id"], name: "index_badgeposts_on_recept_user_id"
  add_index "badgeposts", ["sent_user_id", "created_at"], name: "index_badgeposts_on_sent_user_id_and_created_at"
  add_index "badgeposts", ["sent_user_id"], name: "index_badgeposts_on_sent_user_id"

  create_table "badges", force: :cascade do |t|
    t.boolean  "activeflg"
    t.string   "name"
    t.integer  "outputnumber"
    t.boolean  "optionflg"
    t.text     "explanation"
    t.string   "image"
    t.boolean  "remove_image"
    t.string   "image_cache"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "badges", ["outputnumber"], name: "index_badges_on_outputnumber", unique: true

  create_table "bumons", force: :cascade do |t|
    t.boolean  "activeflg"
    t.string   "name"
    t.integer  "outputnumber"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "bumons", ["outputnumber"], name: "index_bumons_on_outputnumber", unique: true

  create_table "users", force: :cascade do |t|
    t.boolean  "activeflg",       default: true
    t.integer  "bumon_id"
    t.string   "name"
    t.string   "kananame"
    t.string   "nickname"
    t.boolean  "adminflg",        default: false
    t.string   "email"
    t.string   "password_digest"
    t.string   "image1"
    t.boolean  "remove_image1"
    t.string   "image_cache1"
    t.string   "image2"
    t.boolean  "remove_image2"
    t.string   "image_cache2"
    t.text     "myword"
    t.text     "hobby"
    t.string   "message"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["bumon_id"], name: "index_users_on_bumon_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["kananame"], name: "index_users_on_kananame"
  add_index "users", ["name"], name: "index_users_on_name"

end
