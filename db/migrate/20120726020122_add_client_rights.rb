class AddClientRights < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end
  class Right < ActiveRecord::Base
    has_and_belongs_to_many :roles
  end
  RIGHTS = {:view_all_clients => [:herald, :clerk, :senior], 
            :edit_client => [:clerk], 
            :create_client => [:clerk, :guest]}
  def self.up
    RIGHTS.each_pair do |name, roles|
      right = Right.new(:name => name)
      right.roles = roles.map {|r| Role.find_by_name(r)}
      say "Adding right #{right.inspect}"
      right.save!
    end
  end

  def self.down
    RIGHTS.each_key do |name|
      right = Right.find_by_name(name)
      if (right)
        right.roles = []
        right.save!
        say "Destroying #{right.inspect}"
        right.destroy
      end
    end
  end
end
