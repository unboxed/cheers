class AddRecipientsToShoutouts < ActiveRecord::Migration
  def change
    add_column :shoutouts, :recipients, :text
  end
end
