class AddFirstLetter < ActiveRecord::Migration
  class Client < ActiveRecord::Base
  end
  def self.up
    add_column :clients, :first_letter, :string, :length => 1
    Client.all.each do |client|
      name = client.society_name || client.legal_name || "?"
      client.first_letter = name[0..0]
      say "Adding first letter #{client.first_letter}"
      client.save
    end
  end

  def self.down
    remove_column :clients, :first_letter
  end
end
