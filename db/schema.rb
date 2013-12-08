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

ActiveRecord::Schema.define(:version => 20131011180101) do

  create_table "drivers", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "name"
    t.integer  "points",     :default => 0, :null => false
    t.string   "email"
    t.string   "car"          # car model
    t.string   "plate"        # car plate
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "drivers", ["user_id"], :name => "index_drivers_on_user_id", :unique => true

  create_table "order", :force => true do |t|
    t.integer "order_id",        :null => false
    t.string  "name_user"
    t.string  "address"
    t.integer "gps_long"
    t.integer "gps_lst"
    t.integer "user_id_drivers"
    t.boolean "orders"
  end

  create_table "users", :force => true do |t|
    t.string   "device_id",                 :null => false
    t.string   "email"
    t.integer  "points",     :default => 0, :null => false
    t.string   "ref"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "users", ["device_id"], :name => "index_users_on_device_id", :unique => true
  add_index "users", ["ref"], :name => "index_users_on_ref", :unique => true

end
