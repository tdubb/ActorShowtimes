class RemoveTwoColumnsLatitudeAndLongitudeFromActor < ActiveRecord::Migration
  def change
    remove_columns :actors, :latitude
    remove_columns :actors, :longitude
  end
end
