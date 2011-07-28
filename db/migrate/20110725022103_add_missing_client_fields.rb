class AddMissingClientFields < ActiveRecord::Migration
  def self.up
    add_column :clients, :gender, :string
    change_column :clients, :birth_date, :string
    remove_column :clients, :kingdom_id
    drop_table :kingdoms
    add_column :clients, :kingdom, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration 
  end
end
