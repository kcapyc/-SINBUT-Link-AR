class CreateOptions < ActiveRecord::Migration
  def change

  	create_table :options do |t|
  		t.text :name

  		t.timestamps
  	end

  	Option.create :name => 'Category one'
  	Option.create :name => 'Category two'
  	Option.create :name => 'Category three'  	

  end
end
