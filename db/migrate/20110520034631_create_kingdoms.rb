class CreateKingdoms < ActiveRecord::Migration
  def self.up
    create_table :kingdoms do |t|
      t.string :name

      t.timestamps
    end
    
    ['Æthelmearc', 'An Tir', 'Ansteorra', 'Artemisia', 'Atenveldt', 'Atlantia', 'Caid', 
     'Calontir', 'Drachenwald', 'Ealdormere', 'East', 'Gleann Abhann', 'Laurel', 'Lochac', 
     'Meridies', 'Middle', 'Northshield', 'Outlands', 'Trimaris', 'West'].each do |kingdom_name|
       Kingdom.new(:name => kingdom_name).save
    end
    aethelmearc = Kingdom.find_by_name('Æthelmearc')
    add_column :clients, :kingdom_id, :integer, :default => aethelmearc.id
  end

  def self.down
    remove_column :clients, :kingdom_id
    drop_table :kingdoms
  end
end
