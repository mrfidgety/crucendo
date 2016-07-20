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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160719071408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "interaction_id"
    t.text     "content"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "question_id"
  end

  add_index "answers", ["interaction_id"], name: "index_answers_on_interaction_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "due_date"
    t.boolean  "completed",      default: true
    t.datetime "completed_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "active",         default: true
  end

  add_index "goals", ["user_id", "due_date"], name: "index_goals_on_user_id_and_due_date", using: :btree
  add_index "goals", ["user_id"], name: "index_goals_on_user_id", using: :btree

  create_table "interactions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "interactions", ["user_id"], name: "index_interactions_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",     default: false
    t.boolean  "archived",   default: false
    t.integer  "topic_id"
  end

  add_index "questions", ["topic_id"], name: "index_questions_on_topic_id", using: :btree

  create_table "remembers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "remember_digest"
    t.string   "browser"
    t.string   "device"
    t.string   "platform"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "remembers", ["user_id"], name: "index_remembers_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.boolean  "global",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "steps", force: :cascade do |t|
    t.integer  "goal_id"
    t.text     "content"
    t.boolean  "completed",      default: false
    t.datetime "completed_date"
    t.integer  "order"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "steps", ["goal_id"], name: "index_steps_on_goal_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "activation_digest"
    t.datetime "activation_sent_at"
    t.boolean  "activated",                    default: false
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.boolean  "admin",                        default: false
    t.string   "login_digest"
    t.datetime "login_sent_at"
    t.integer  "year_of_birth",      limit: 2
    t.string   "gender"
    t.string   "country_code"
    t.string   "new_email"
    t.datetime "new_email_sent_at"
    t.string   "new_email_digest"
    t.boolean  "new_email_approved",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "answers", "interactions"
  add_foreign_key "answers", "questions"
  add_foreign_key "goals", "users"
  add_foreign_key "interactions", "users"
  add_foreign_key "questions", "topics"
  add_foreign_key "remembers", "users"
  add_foreign_key "steps", "goals"
end
