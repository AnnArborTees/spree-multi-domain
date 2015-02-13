Spree::Taxonomy.class_eval do
  has_and_belongs_to_many :stores, :join_table => 'spree_taxonomies_stores'

  def self.without_stores
    where("NOT EXISTS (SELECT 1 FROM spree_taxonomies_stores WHERE spree_taxonomies.id = spree_taxonomies_stores.taxonomy_id)")
  end
end
