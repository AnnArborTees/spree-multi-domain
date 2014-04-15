class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all
  end

  def show
    session[:stores] = params[:store_codes].split('/')
    # TODO make a StoreCombination object or something
    # TODO or alter the multi_domain.rb searcher to accomodate for this shit
    # TODO remember also to make sure the existing tests still work after this

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
