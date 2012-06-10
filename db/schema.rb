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

ActiveRecord::Schema.define(:version => 20120610052107) do

  create_table "contents", :force => true do |t|
    t.integer  "user_id",   :limit => 255,                        :null => false
    t.string   "url",                                             :null => false
    t.integer  "rate_up",                  :default => 0,         :null => false
    t.integer  "rate_down",                :default => 0,         :null => false
    t.datetime "post_date",                                       :null => false
    t.string   "source",                                          :null => false
    t.string   "access",                   :default => "friends", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token",        :default => "", :null => false
    t.datetime "remember_created_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
