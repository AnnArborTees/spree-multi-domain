module Spree
	HomeController.class_eval do
		def index
			session[:store] = nil
			# TODO if session[:store].matches_domain then do a redirect as stated on your notepad!
			# maybe this goes in the StoresController though. NOT SURE


			add_current_store_ids_to_params
			@searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
		end
	end
end