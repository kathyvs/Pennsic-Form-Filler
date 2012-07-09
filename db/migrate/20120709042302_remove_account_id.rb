class RemoveAccountId < ActiveRecord::Migration
  class Account < ActiveRecord::Base; end
  class Event < ActiveRecord::Base
    has_and_belongs_to_many :accounts
  end
  def self.up
    remove_column :events, :account_id
  end

  def self.down
    add_column :events, :account_id, :integer
    Event.all.each do |e|
      unless (e.accounts.empty?)
        e.account_id = e.accounts[0].id
      end
    end
  end
end
