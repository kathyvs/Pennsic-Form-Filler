class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :society_name
      t.string :legal_name
      t.string :address_1
      t.string :address_2
      t.string :branch_name
      t.string :phone_number
      t.date :birth_date
      t.string :email
      t.integer :event_id
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
