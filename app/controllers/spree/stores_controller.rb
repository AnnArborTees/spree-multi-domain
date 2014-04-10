class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all
  end

  def show
    session[:store] = Spree::Store.all.reject { |s| s.code != params[:id] }.first.code

    if current_store.default
      redirect_to spree.root_path
    else
      params[:current_store_id] = current_store.id
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      render 'spree/home/index'
    end
  end

end
