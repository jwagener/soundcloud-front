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

ActiveRecord::Schema.define(:version => 20100810102949) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error",                :null => false
    t.datetime "run_at",                    :null => false
    t.datetime "locked_at",                 :null => false
    t.datetime "failed_at",                 :null => false
    t.text     "locked_by",                 :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "upload_jobs", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.string   "file_url",      :null => false
    t.text     "params",        :null => false
    t.string   "state",         :null => false
    t.string   "error_message", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "sc_user_id",          :null => false
    t.string   "sc_username",         :null => false
    t.string   "access_token",        :null => false
    t.string   "access_token_secret", :null => false
    t.string   "upload_secret",       :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

end
