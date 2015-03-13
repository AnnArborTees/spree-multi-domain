class AddCreateYourOwnLinkToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :create_your_own_link, :string
  end
end
