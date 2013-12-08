class CreateActorsUsersNoId < ActiveRecord::Migration
  def change
    create_table :actors_users, id: false do |t|
      t.integer :actor_id
      t.integer :user_id    
  	end
  end
end
