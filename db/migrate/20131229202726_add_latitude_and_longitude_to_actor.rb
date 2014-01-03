class AddLatitudeAndLongitudeToActor < ActiveRecord::Migration
  def change
    add_column :actors, :latitude, :float
    add_column :actors, :longitude, :float
  end
end
