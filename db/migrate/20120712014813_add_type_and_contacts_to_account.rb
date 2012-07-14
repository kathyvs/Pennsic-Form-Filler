class AddTypeAndContactsToAccount < ActiveRecord::Migration
  def self.up
    add_column(:accounts, 'type', :string, :default => 'Account', :null => false, :limit => 15)
    add_column(:accounts, 'sca_name', :string)
    add_column(:accounts, 'contact_info', :string)
  end

  def self.down
    remove_column(:accounts, :contact_info)
    remove_column(:accounts, :sca_name)
    remove_column(:accounts, :type)
  end
end
