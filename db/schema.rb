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

ActiveRecord::Schema.define(:version => 20120801014146) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",            :limit => 15, :default => "Account", :null => false
    t.string   "sca_name"
    t.string   "contact_info"
  end

  add_index "accounts", ["name", "hashed_password"], :name => "login_idx"
  add_index "accounts", ["sca_name"], :name => "sca_name_idx"

  create_table "accounts_events", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "account_id"
  end

  add_index "accounts_events", ["account_id"], :name => "index_accounts_events_on_account_id"
  add_index "accounts_events", ["event_id"], :name => "index_accounts_events_on_event_id"

  create_table "accounts_roles", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "role_id"
  end

  add_index "accounts_roles", ["account_id"], :name => "index_accounts_roles_on_account_id"
  add_index "accounts_roles", ["role_id"], :name => "index_accounts_roles_on_role_id"

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
    t.string   "first_letter"
  end

  add_index "clients", ["event_id"], :name => "index_clients_on_event_id"
  add_index "clients", ["first_letter"], :name => "index_clients_on_first_letter"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_current", :default => false, :null => false
  end

  add_index "events", ["is_current"], :name => "event_current_idx"

  create_table "forms", :force => true do |t|
    t.string   "type"
    t.string   "action_type"
    t.string   "herald"
    t.string   "heralds_email"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action_type_other"
    t.string   "action_change_type"
    t.string   "resub_from"
    t.string   "name_type"
    t.string   "name_type_other"
    t.string   "submitted_name"
    t.string   "documentation",          :limit => 1000
    t.binary   "doc_pdf",                :limit => 5242880
    t.date     "date_submitted"
    t.boolean  "needs_review"
    t.string   "authentic_text"
    t.string   "authentic_flags"
    t.boolean  "no_changes_minor_flag"
    t.boolean  "no_changes_major_flag"
    t.string   "preferred_changes_type"
    t.string   "preferred_changes_text"
    t.boolean  "no_holding_name_flag"
    t.string   "previous_kingdom"
    t.string   "previous_name"
    t.string   "original_returned"
    t.string   "gender_name"
    t.string   "blazon"
    t.string   "restricted_charges"
    t.string   "associated_name"
    t.string   "co_owner_name"
    t.boolean  "is_joint_flag"
    t.string   "release1"
    t.string   "release2"
    t.boolean  "is_intermediate"
    t.boolean  "printed"
  end

  add_index "forms", ["client_id"], :name => "index_forms_on_client_id"
  add_index "forms", ["type"], :name => "index_forms_on_type"

  create_table "rights", :force => true do |t|
    t.string "name"
  end

  add_index "rights", ["name"], :name => "index_rights_on_name"

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  add_index "rights_roles", ["right_id"], :name => "index_rights_roles_on_right_id"
  add_index "rights_roles", ["role_id"], :name => "index_rights_roles_on_role_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

end
