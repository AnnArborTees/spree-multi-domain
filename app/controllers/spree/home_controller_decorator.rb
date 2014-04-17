module Spree
	HomeController.class_eval do
		def index
			session[:store] = nil
			
			add_current_store_ids_to_params
			@searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
		end
	end
end