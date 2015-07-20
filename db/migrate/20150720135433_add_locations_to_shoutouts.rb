class AddLocationsToShoutouts < ActiveRecord::Migration
  def change
    add_column :shoutouts, :locations, :text
  end
end
