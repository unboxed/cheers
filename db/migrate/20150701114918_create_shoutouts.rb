class CreateShoutouts < ActiveRecord::Migration
  def change
    create_table :shoutouts do |t|
      t.string :sender
      t.string :recipient
      t.string :message

      t.timestamps null: false
    end
  end
end
