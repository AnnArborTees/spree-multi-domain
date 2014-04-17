class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all
  end

  def show
    @store_path = params[:store_codes]
    session[:store] = @store_path

    if current_store.matches_domain? current_domain
      beginning_index = @store_path.index('/')+1
      if beginning_index
        redirect_to "#{spree.root_path}stores/#{@store_path[beginning_index..-1]}"
      else
        redirect_to spree.root_path
      end
    else
      add_current_store_ids_to_params
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      render 'spree/home/index'  
    end

    #     ===BEGIN OLD SHIT===
    #session[:store] = Spree::Store.with_code(params[:id]).code
    #
    #if current_store.id == current_store_for_domain.id
    #  redirect_to spree.root_path
    #else
    #  params[:current_store_id] = current_store.id
    #  @searcher = build_searcher(params)
    #  @products = @searcher.retrieve_products
    #  @taxonomies = Spree::Taxonomy.includes(root: :children)
    #  render 'spree/home/index'
    #end
  end

end
