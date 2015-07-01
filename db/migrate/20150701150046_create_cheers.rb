class CreateCheers < ActiveRecord::Migration
  def change
    create_table :cheers do |t|
      t.references :shoutout, index: true, foreign_key: true
      t.string :sender

      t.timestamps null: false
    end
  end
end
