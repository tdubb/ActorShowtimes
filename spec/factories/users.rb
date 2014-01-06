# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.email { Faker::Internet.email }
    f.password { Faker::Internet.password }
  end
end

    # t.string   "name"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.string   "email",                  default: "", null: false
    # t.string   "encrypted_password",     default: "", null: false
    # t.string   "reset_password_token"
    # t.datetime "reset_password_sent_at"
    # t.datetime "remember_created_at"
    # t.integer  "sign_in_count",          default: 0,  null: false
    # t.datetime "current_sign_in_at"
    # t.datetime "last_sign_in_at"
    # t.string   "current_sign_in_ip"
    # t.string   "last_sign_in_ip"