class CreateForms < ActiveRecord::Migration
  def self.up
    create_table :forms do |t|
      t.string :type
      t.string :action_type
      t.string :action_sub_type
      t.string :herald
      t.string :heralds_email
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :forms
  end
end
