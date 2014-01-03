class RemoveTwoColumnsLatitudeAndLongitudeFromActor < ActiveRecord::Migration
  def change
    remove_column :actors, :latitude
    remove_column :actors, :longitude
  end
end
