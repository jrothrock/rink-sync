class AddColumnsToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :title, :string
    add_column :songs, :api_url, :string
  end
end
