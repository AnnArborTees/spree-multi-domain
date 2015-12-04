class AddPageIdToStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :page_id, :integer, index: true
  end
end
