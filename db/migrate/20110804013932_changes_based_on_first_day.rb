class ChangesBasedOnFirstDay < ActiveRecord::Migration
  def self.up
    add_column :forms, :is_intermediate, :boolean
    add_column :forms, :printed, :boolean
    change_column :forms, :documentation, :string, :limit => 1000
  end

  def self.down
    remove_column :forms, :is_intermediate, :printed
    change_column :forms, :documentation, :string, :limit => 255
  end
end
