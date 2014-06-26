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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140403142334) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "alerts", :force => true do |t|
    t.integer  "consumable_id"
    t.integer  "user_id"
    t.integer  "building_id"
    t.text     "message"
    t.integer  "count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "assets", :force => true do |t|
    t.integer  "room_id"
    t.string   "tag"
    t.string   "os"
    t.integer  "model_id"
    t.string   "serial"
    t.date     "purchase"
    t.integer  "cost"
    t.integer  "vendor_id"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "super"
    t.string   "name"
  end

  create_table "assignments", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "building_id"
  end

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "short"
    t.integer  "storeroom_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "consumables", :force => true do |t|
    t.string   "name"
    t.string   "short"
    t.decimal  "cost",       :precision => 6, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "target"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "auth_attribute"
    t.string   "auth_value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "inventories", :force => true do |t|
    t.integer  "consumable_id"
    t.integer  "room_id"
    t.integer  "count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "loans", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.text     "use"
    t.boolean  "approved"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "missions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.integer  "manufacturer_id"
    t.integer  "rtype_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string   "priority"
    t.integer  "securable_id"
    t.string   "securable_type"
    t.integer  "principal_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "see"
    t.boolean  "submit"
    t.boolean  "admin"
  end

  create_table "photos", :force => true do |t|
    t.string   "photographable_type"
    t.integer  "photographable_id"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "principals", :force => true do |t|
    t.string   "authorizable_type"
    t.integer  "authorizable_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "requests", :force => true do |t|
    t.integer "loan_id"
    t.integer "rtype_id"
  end

  create_table "returns", :force => true do |t|
    t.integer  "loan_id"
    t.integer  "asset_id"
    t.boolean  "returned"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "building_id"
    t.text     "notes"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "department_id"
    t.integer  "default_asset_id"
  end

  create_table "rtypes", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "loanable"
  end

  create_table "shortcuts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "container_id"
    t.string   "container_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "position"
  end

  create_table "tags", :force => true do |t|
    t.integer "user_id"
    t.integer "ticket_id"
  end

  create_table "ticketqueues", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "parent_id"
    t.string   "parent_type"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "ticketqueue_id"
    t.integer  "status"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "submitter_id"
    t.datetime "due"
    t.integer  "room_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "email"
    t.boolean  "administrator"
    t.boolean  "support"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "uses", :force => true do |t|
    t.integer  "consumable_id"
    t.integer  "room_id"
    t.integer  "count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
