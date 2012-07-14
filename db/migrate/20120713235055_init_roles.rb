class InitRoles < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end
  
  def self.add_role(sym)
    Role.new(:name => sym.to_s).save!
  end
  
  def self.remove_role(sym)
    Role.find_by_name(sym.to_s).destroy
  end
  
  def self.up
    add_role :admin
    add_role :senior
    add_role :clerk
    add_role :herald
    add_role :guest
  end

  def self.down
    remove_role :guest
    remove_role :herald
    remove_role :clerk
    remove_role :senior
    remove_role :admin
  end
end
