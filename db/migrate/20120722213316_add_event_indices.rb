class AddEventIndices < ActiveRecord::Migration
  def self.up
    add_index :accounts_events, :account_id
    add_index :accounts_events, :event_id
  end

  def self.down
    #Harmless
  end
end
