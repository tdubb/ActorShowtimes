class Actor < ActiveRecord::Base
  validates :name, presence: true
  validates :movie_db_id, presence: true
	has_and_belongs_to_many :users

end
