class CreateEventRights < ActiveRecord::Migration
  class Right < ActiveRecord::Base
    
  end
  
  class Role < ActiveRecord::Base
    has_and_belongs_to_many :rights
  end
  
  EVENT_RIGHTS = ["modify_event", "set_current_event"]
  def self.up
    role = Role.find_by_name(:admin)
    EVENT_RIGHTS.each do |r|
      right = Right.new(:name => r)
      say "Creating right #{right.inspect}"
      right.save!
      role.rights << right
    end
    say "Addings rights to role #{role.name}"
  end

  def self.down
    rights = Right.where("name in (?)", EVENT_RIGHTS)
    rights.each do |right|
      say "Deleting right #{right.inspect}"
      right.destroy
    end    
  end
end
