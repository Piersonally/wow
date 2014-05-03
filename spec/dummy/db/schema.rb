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

ActiveRecord::Schema.define(version: 20140503201437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "wow_auctions", force: true do |t|
    t.integer  "realm_id"
    t.string   "auction_house"
    t.string   "auc"
    t.integer  "item"
    t.string   "owner"
    t.string   "owner_realm"
    t.integer  "buyout"
    t.integer  "quantity"
    t.integer  "rand"
    t.integer  "seed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wow_auctions", ["auc"], name: "index_wow_auctions_on_auc", using: :btree
  add_index "wow_auctions", ["item"], name: "index_wow_auctions_on_item", using: :btree
  add_index "wow_auctions", ["owner", "owner_realm"], name: "index_wow_auctions_on_owner_and_owner_realm", using: :btree
  add_index "wow_auctions", ["realm_id"], name: "index_wow_auctions_on_realm_id", using: :btree

  create_table "wow_realms", force: true do |t|
    t.string   "slug"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "polling_enabled", default: false
  end

  add_index "wow_realms", ["polling_enabled"], name: "index_wow_realms_on_polling_enabled", using: :btree

  add_foreign_key "wow_auctions", "wow_realms", name: "wow_auctions_realm_id_fk", column: "realm_id"

end
