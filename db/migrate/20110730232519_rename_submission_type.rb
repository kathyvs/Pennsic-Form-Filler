class RenameSubmissionType < ActiveRecord::Migration
  def self.up
    rename_column :forms, :submission_type, :name_type
    rename_column :forms, :submission_type_other, :name_type_other
  end

  def self.down
    rename_column :forms, :name_type, :submission_type
    rename_column :forms, :name_type_other, :submission_type_other
  end
end
