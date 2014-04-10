class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all
  end

  def show
    session[:store] = Spree::Store.all.reject { |s| s.code != params[:id] }.first.code
      
    @searcher = build_searcher(params)
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    if current_store.default
      redirect_to spree.root_path
    else
      render 'spree/home/index'
    end
  end

end
