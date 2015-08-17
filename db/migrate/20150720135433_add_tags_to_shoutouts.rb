class AddTagsToShoutouts < ActiveRecord::Migration
  def change
    add_column :shoutouts, :tags, :text
  end
end
