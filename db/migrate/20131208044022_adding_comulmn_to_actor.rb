class AddingComulmnToActor < ActiveRecord::Migration
  def change
  	add_column :actors, :movie_db_id, :string
  end
end
