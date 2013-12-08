class CreateAssociationBtwActorsAndUsers < ActiveRecord::Migration
  def change
    create_table :association_btw_actors_and_users do |t|
      t.belongs_to :actor
      t.belongs_to :user
    end
  end
end
