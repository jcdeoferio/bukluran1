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

ActiveRecord::Schema.define(:version => 20090402065519) do

  create_table "accounts", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.integer  "osa_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "awards", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "file_path"
    t.string   "classification"
    t.string   "description"
    t.string   "award_giving_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_reports", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "category"
    t.string   "description"
    t.date     "date"
    t.string   "venue"
    t.string   "head"
    t.string   "file_path1"
    t.string   "file_path2"
    t.string   "file_path3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "category"
    t.string   "description"
    t.date     "date"
    t.string   "venue"
    t.string   "head"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.integer  "student_id"
    t.integer  "organization_id"
    t.string   "position"
    t.integer  "semester"
    t.integer  "year"
    t.boolean  "confirm"
    t.string   "confirmation_key"
    t.boolean  "sentcnfrm"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.integer  "account_id"
    t.string   "name",               :default => ""
    t.string   "acronym",            :default => ""
    t.string   "nature",             :default => ""
    t.string   "category",           :default => ""
    t.string   "status",             :default => ""
    t.string   "approved_by",        :default => ""
    t.string   "mailing_address",    :default => ""
    t.string   "email_org",          :default => ""
    t.string   "email_head",         :default => ""
    t.date     "date_established"
    t.date     "date_incorporation"
    t.date     "date_approved"
    t.text     "description",        :default => ""
    t.text     "comment",            :default => ""
    t.boolean  "sec_incorporated",   :default => false
    t.boolean  "interviewed",        :default => false
    t.string   "adviser1_name",      :default => ""
    t.string   "adviser1_dept",      :default => ""
    t.string   "adviser1_position",  :default => ""
    t.string   "adviser1_mobile",    :default => ""
    t.string   "adviser1_home",      :default => ""
    t.string   "adviser1_office",    :default => ""
    t.string   "adviser1_email",     :default => ""
    t.string   "adviser2_name",      :default => ""
    t.string   "adviser2_dept",      :default => ""
    t.string   "adviser2_position",  :default => ""
    t.string   "adviser2_mobile",    :default => ""
    t.string   "adviser2_home",      :default => ""
    t.string   "adviser2_office",    :default => ""
    t.string   "adviser2_email",     :default => ""
    t.string   "adviser3_name",      :default => ""
    t.string   "adviser3_dept",      :default => ""
    t.string   "adviser3_position",  :default => ""
    t.string   "adviser3_mobile",    :default => ""
    t.string   "adviser3_home",      :default => ""
    t.string   "adviser3_office",    :default => ""
    t.string   "adviser3_email",     :default => ""
    t.boolean  "editable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "osas", :force => true do |t|
    t.integer  "account_id"
    t.string   "coordinator"
    t.boolean  "isopen",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.integer  "student_no"
    t.integer  "year_level"
    t.string   "name"
    t.string   "nickname"
    t.string   "degree_program"
    t.string   "course"
    t.string   "college"
    t.string   "gender"
    t.boolean  "enrolled"
    t.string   "webmail"
    t.string   "permanent_address"
    t.string   "present_address"
    t.string   "title"
    t.string   "guardian"
    t.string   "guardian_address"
    t.integer  "guardian_telno"
    t.integer  "contact_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
