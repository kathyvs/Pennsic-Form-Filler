class AddAccountIndices < ActiveRecord::Migration
  def self.up
    add_index :accounts, [:name, :hashed_password], :name => 'login_idx'
    add_index :accounts, :sca_name, :name => 'sca_name_idx'
    add_index :accounts_roles, :account_id
    add_index :accounts_roles, :role_id
    add_index :rights, :name
    add_index :rights_roles, :right_id
    add_index :rights_roles, :role_id
    add_index :roles, :name
  end

  def self.down
    #Harmless
  end
end
