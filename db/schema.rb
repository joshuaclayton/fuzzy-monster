# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081103215946) do

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.string  "slug"
    t.text    "description"
    t.integer "position",     :default => 1
    t.integer "topics_count", :default => 0
  end

  add_index "forums", ["position"], :name => "index_forums_on_position"
  add_index "forums", ["slug"], :name => "index_forums_on_slug"

  create_table "privileges", :force => true do |t|
    t.string "name"
  end

  add_index "privileges", ["name"], :name => "index_privileges_on_name"

  create_table "privileges_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "privilege_id"
  end

  add_index "privileges_roles", ["role_id"], :name => "index_privileges_roles_on_role_id"
  add_index "privileges_roles", ["privilege_id"], :name => "index_privileges_roles_on_privilege_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "creator_id"
    t.string   "title"
    t.string   "slug"
    t.boolean  "sticky",          :default => false
    t.boolean  "locked",          :default => false
    t.integer  "hits",            :default => 0
    t.datetime "last_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topics", ["slug"], :name => "index_topics_on_slug"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
  add_index "topics", ["sticky"], :name => "index_topics_on_sticky"
  add_index "topics", ["hits"], :name => "index_topics_on_hits"
  add_index "topics", ["creator_id"], :name => "index_topics_on_creator_id"
  add_index "topics", ["last_updated_at", "sticky"], :name => "index_topics_on_last_updated_at_and_sticky"
  add_index "topics", ["last_updated_at"], :name => "index_topics_on_last_updated_at"

  create_table "user_reminders", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expires_at"
  end

  add_index "user_reminders", ["user_id", "token", "expires_at"], :name => "index_user_reminders_on_user_id_and_token_and_expires_at"

  create_table "users", :force => true do |t|
    t.string   "password_hash"
    t.string   "salt"
    t.string   "email_address"
    t.integer  "role_id"
    t.boolean  "active"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
  end

  add_index "users", ["role_id"], :name => "index_users_on_role_id"
  add_index "users", ["active"], :name => "index_users_on_active"
  add_index "users", ["email_address"], :name => "index_users_on_email_address"
  add_index "users", ["username"], :name => "index_users_on_username"

end
