# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :actor do |f|
    f.name { Faker::Name.name }
    f.picture_url { Faker::Internet.url }
 #   f.movie_db_id "1"
  end
end

    # t.string   "name"
    # t.string   "picture_url"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.string   "movie_db_id"