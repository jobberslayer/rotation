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

ActiveRecord::Schema.define(:version => 20130301223430) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "rotation"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["user_name"], :name => "index_users_on_uname", :unique => true

  create_table "vol_group_relationships", :force => true do |t|
    t.integer  "volunteer_id"
    t.integer  "group_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "vol_group_relationships", ["group_id"], :name => "index_vol_job_relationships_on_job_id"
  add_index "vol_group_relationships", ["volunteer_id", "group_id"], :name => "index_vol_job_relationships_on_volunteer_id_and_job_id", :unique => true
  add_index "vol_group_relationships", ["volunteer_id"], :name => "index_vol_job_relationships_on_volunteer_id"

  create_table "volunteers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "volunteers", ["first_name", "last_name", "email"], :name => "index_volunteers_on_first_name_and_last_name_and_email", :unique => true

end
