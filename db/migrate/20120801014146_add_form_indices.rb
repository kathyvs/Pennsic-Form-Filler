class AddFormIndices < ActiveRecord::Migration
  def self.up
    add_index :forms, :client_id
    add_index :forms, :type

  end

  def self.down
    #Harmless
  end
end
