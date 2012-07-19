class ReworkRoles < ActiveRecord::Migration
  def self.up
    r = Role.find_by_name(:admin)
    Account.all.each do |a|
      a.roles << r if a.is_admin
      a.save!
    end
    
    remove_column(:accounts, :is_admin)
  end

  def self.down
    add_column(:accounts, :is_admin, :boolean, :default => false)
    r = Role.find_by_name(:admin)
    Account.all.each do |a|
      a.is_admin = a.roles.member?(r)
      a.roles.delete(r)
    end
  end
end
