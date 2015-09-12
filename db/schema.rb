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

ActiveRecord::Schema.define(:version => 20130405142105) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "firstname"
    t.string   "email"
    t.string   "phone"
    t.integer  "client_id"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "contacts", ["client_id"], :name => "index_contacts_on_client_id"

  create_table "employments", :force => true do |t|
    t.integer  "employer_id"
    t.integer  "employee_id"
    t.time     "workingtime_per_day"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "accepted",                    :default => false
    t.integer  "num_vacation_days",           :default => 0
    t.integer  "num_vacation_days_remaining", :default => 0
    t.date     "employment_date"
  end

  add_index "employments", ["employee_id"], :name => "index_employments_on_employee_id"
  add_index "employments", ["employer_id"], :name => "index_employments_on_employer_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "status"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "content"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "subject"
    t.boolean  "read",         :default => false
  end

  create_table "projectnotes", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "project_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projectnotes", ["project_id"], :name => "index_projectnotes_on_project_id"
  add_index "projectnotes", ["sender_id"], :name => "index_projectnotes_on_sender_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "planned_efforts", :default => 0
    t.integer  "Client_id"
    t.boolean  "finished",        :default => false
    t.integer  "projecttask_id"
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "projecttasks", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.boolean  "billable"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projecttasks", ["project_id"], :name => "index_projecttasks_on_project_id"

  create_table "timerecords", :force => true do |t|
    t.integer  "User_id"
    t.integer  "Project_id"
    t.datetime "start"
    t.datetime "end"
    t.time     "duration"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                         :default => "",     :null => false
    t.string   "encrypted_password",                            :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                 :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.string   "firstname"
    t.string   "name"
    t.string   "company"
    t.integer  "employment_id"
    t.string   "role",                            :limit => 30, :default => "user"
    t.boolean  "inactive",                                      :default => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "maxNumProjects",                                :default => 3
    t.integer  "maxNumMembershipsForOwnProjects",               :default => 3
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["inactive"], :name => "index_users_on_inactive"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
