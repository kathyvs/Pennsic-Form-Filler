class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name, :length => 25
      t.string :hashed_password
      t.string :salt
      t.boolean :is_admin, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
