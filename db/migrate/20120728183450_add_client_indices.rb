class AddClientIndices < ActiveRecord::Migration
  def self.up
     add_index :clients, :event_id
     add_index :clients, :first_letter
  end

  def self.down
    #Harmless
  end
end
