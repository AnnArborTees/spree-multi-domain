Spree::Taxonomy.class_eval do
  has_and_belongs_to_many :stores, :join_table => 'spree_taxonomies_stores'
end
