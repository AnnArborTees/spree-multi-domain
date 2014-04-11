class AddChildrenToStores < ActiveRecord::Migration
  def change
  	add_column :stores, :parent_id, :integer
  	add_index :stores,  :parent_id
  end
end
