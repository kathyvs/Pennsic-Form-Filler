class AddDeviceFields < ActiveRecord::Migration
  def self.up
    add_column :forms, :blazon, :string
    add_column :forms, :restricted_charges, :string
  end

  def self.down
    remove_column :forms, :blazon, :restricted_charges
  end
end
