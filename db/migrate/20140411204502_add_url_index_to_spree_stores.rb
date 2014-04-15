class AddUrlIndexToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :url_index, :integer
  end
end
