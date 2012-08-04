class AddNotesColumn < ActiveRecord::Migration
  def self.up
    add_column :forms, :notes, :text, :limit => 500
  end

  def self.down
    remove_column :forms, :notes
  end
end
