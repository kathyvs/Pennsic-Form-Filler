class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string
    end
    
    create_table :accounts_roles, :id => false do |t|
      t.column :account_id, :integer
      t.column :role_id, :integer
    end
  end

  def self.down
    drop_table :accounts_roles
    drop_table :roles
  end
end
