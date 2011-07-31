class AddBadgeFields < ActiveRecord::Migration
  def self.up
    add_column :forms, :associated_name, :string
    add_column :forms, :co_owner_name, :string
    add_column :forms, :is_joint_flag, :boolean
    add_column :forms, :release1, :string
    add_column :forms, :release2, :string
  end

  def self.down
    drop_column :forms, :associated_name, :co_owner_name, :is_joint_flag
    drop_column :forms, :release1, :release2
  end
end
