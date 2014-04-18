class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all
  end

  def show
    @store_path = params[:store_codes]
    session[:store] = @store_path

    # TODO validate order
    
    if current_store.has_duplicate?
      if current_store.matches_domain? && current_store[0].id == current_store[1].id
        redirect_to current_store[1..-1].full_path(spree.root_path)
      else
        render_404
      end
    elsif current_store.ordered_properly?
      add_current_store_ids_to_params
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      render 'spree/home/index'
    else
      render_404
    end
  end

private
  def render_404
    render :file => "#{Rails.root.to_s}/public/404.html",  :status => 404
  end

end
