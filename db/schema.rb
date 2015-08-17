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

ActiveRecord::Schema.define(version: 20150720135433) do

  create_table "cheers", force: :cascade do |t|
    t.integer  "shoutout_id"
    t.string   "sender"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "cheers", ["shoutout_id"], name: "index_cheers_on_shoutout_id"

  create_table "shoutouts", force: :cascade do |t|
    t.string   "sender"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "recipients"
    t.text     "tags"
  end

end
