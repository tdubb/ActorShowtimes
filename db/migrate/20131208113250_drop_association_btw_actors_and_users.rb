class DropAssociationBtwActorsAndUsers < ActiveRecord::Migration
  def down
  	drop_table :association_btw_actors_and_users
  end
end
