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

ActiveRecord::Schema.define(:version => 20090401060019) do

  create_table "accounts", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "administrators", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "classification"
    t.text     "description"
    t.string   "from"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_files", :force => true do |t|
    t.string   "directory_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "category"
    t.text     "description"
    t.date     "date"
    t.string   "venue"
    t.string   "event_head"
    t.text     "report"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "student_id"
    t.integer  "organization_id"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "acronym"
    t.date     "date_established"
    t.text     "description"
    t.string   "tambayan_address"
    t.string   "nature"
    t.string   "category"
    t.string   "mailing_address"
    t.string   "email_org"
    t.string   "email_head"
    t.boolean  "sec_incorporated"
    t.date     "incorporation_date"
    t.string   "adviser1"
    t.string   "adviser2"
    t.string   "adviser3"
    t.boolean  "interview"
    t.integer  "status"
    t.date     "date_approved"
    t.string   "college"
    t.text     "profile"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "osas", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.integer  "student_no"
    t.string   "name"
    t.string   "degree_program"
    t.string   "gender"
    t.boolean  "enrolled"
    t.string   "webmail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
