class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :video_id
      t.string :game
      t.string :show
      t.string :title
      t.string :part
      t.string :duration
      t.string :thumbnail_url

      t.timestamps null: false
    end
  end
end
