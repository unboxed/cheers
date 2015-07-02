class RemoveRecipientFromShoutouts < ActiveRecord::Migration
  def change
    remove_column :shoutouts, :recipient, :string
  end
end
