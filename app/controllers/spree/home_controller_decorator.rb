module Spree
  HomeController.class_eval do
    def index
      session[:store] = nil

      add_current_store_id_to_params
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = get_taxonomies
    end
  end
end
