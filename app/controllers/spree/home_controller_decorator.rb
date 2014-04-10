module Spree
	HomeController.class_eval do
		def index
			session[:store] = Spree::Store.default.first.code

			params[:current_store_id] = current_store.id
			@searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
		end
	end
end