class AddCurrentToEvents < ActiveRecord::Migration
  def self.up
    add_column(:events, 'is_current', :boolean, :default => false, :null => false)
    add_index(:events, :is_current, :name => 'event_current_idx')
  end

  def self.down
    remove_column(:events, 'is_current')
  end
end
