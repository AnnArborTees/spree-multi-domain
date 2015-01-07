class AddParentToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :parent_id, :integer
  end
end
