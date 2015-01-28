class AddStoreIdToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :store_id, :integer
  end
end
