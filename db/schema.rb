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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110725022103) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.boolean  "is_admin",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "society_name"
    t.string   "legal_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "branch_name"
    t.string   "phone_number"
    t.string   "birth_date"
    t.string   "email"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender"
    t.string   "kingdom"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", :force => true do |t|
    t.string   "type"
    t.string   "action_type"
    t.string   "action_sub_type"
    t.string   "herald"
    t.string   "heralds_email"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
