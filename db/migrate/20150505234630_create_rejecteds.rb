class CreateRejecteds < ActiveRecord::Migration
  def change
    create_table :rejecteds do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
