class RenameAndDropColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :songs, :speed
    rename_column :songs, :decibles, :decibels
  end
end
