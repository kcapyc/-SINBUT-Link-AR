class CreateClients < ActiveRecord::Migration
  def change
  	
  	create_table :clients do |t|
  		t.text :name
  		t.text :phone
  		t.text :datestamp
  		t.text :option
  		t.text :message

  		t.timestamps
  	end

  end
end
