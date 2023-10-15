class AddDeciblesToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :decibles, :integer
  end
end
