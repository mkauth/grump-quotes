class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :content
      t.integer :episode_id
      t.string :time

      t.timestamps null: false
    end
  end
end
