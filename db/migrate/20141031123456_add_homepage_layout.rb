class AddHomepageLayout < ActiveRecord::Migration
  def change
    add_column :spree_stores, :homepage_layout, :string
  end
end
