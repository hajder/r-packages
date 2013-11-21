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

ActiveRecord::Schema.define(version: 20131121093118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "package_versions", force: true do |t|
    t.integer  "package_id"
    t.string   "version"
    t.string   "r_version"
    t.text     "dependencies"
    t.text     "suggestions"
    t.date     "publication"
    t.string   "title"
    t.text     "description"
    t.text     "author"
    t.text     "maintainer"
    t.string   "license"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "package_versions", ["package_id"], name: "index_package_versions_on_package_id", using: :btree

  create_table "packages", force: true do |t|
    t.string   "name"
    t.string   "latest_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
