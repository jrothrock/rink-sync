class AddSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :url, null: false
      t.string :start_time
      t.string :end_time
      t.string :speed, null: false, default: "1"
      t.boolean :nsfw, null: false, defualt: false
    end

    add_reference :songs, :user, foreign_key: true
  end
end
