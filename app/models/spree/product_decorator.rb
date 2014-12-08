Spree::Product.class_eval do
  has_and_belongs_to_many :stores, :join_table => 'spree_products_stores'

  searchable :if => :indexable? do
    text :store_names_text do
      store_names.join(',')
    end
    string :store_names, :multiple => true
    integer :store_ids, :multiple => true
  end

  def store_names
    stores.map(&:name).uniq
  end

  def store_ids
    stores.map(&:id).uniq
  end

  scope :by_store, lambda { |store|
    if store.is_a? Array
    	# TODO this may be a bit sloppy, but I cannot find a way to
    	# do this with pure SQL (not that I'm great at SQL)
    	valid_product_ids = []
      joins(:stores).where("spree_products_stores.store_id IN (?)", store).each do |product|
      	valid_product_ids << product.id if (store - product.store_ids).blank?
      end
      where(id: valid_product_ids)
    else
      joins(:stores).where("spree_products_stores.store_id = ?", store)
    end
   }


end
