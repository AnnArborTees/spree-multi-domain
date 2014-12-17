class CreateSpreeHomepageProducts < ActiveRecord::Migration
  def change
    create_table :spree_homepage_products do |t|
      t.references :product
      t.references :homepage
      t.integer :position
      t.timestamps
    end
    add_index :spree_homepage_products, :product_id
    add_index :spree_homepage_products, :homepage_id
  end
end
