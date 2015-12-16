class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all.order(:name)
  end

  def show
    if /^\d+$/ =~ params[:id]
      @store = Spree::Store.find_by(id: params[:id])
      return render_404 if @store.nil?
      return redirect_to spree.store_path(@store.slug)
    end

    @store = @current_store = Spree::Store.find_by(slug: params[:id])
    return render_404 if @store.nil?
    return redirect_to spree.root_path if @store == domain_store

    add_current_store_id_to_params

    @page = @current_store.try(:page)
    if @page
      render 'spree/static_content/show'
    else
      @searcher = build_searcher(params)
      @products = @searcher.retrieve_products
      @taxonomies = @store.taxonomies.includes(root: :children)

      render 'spree/home/index'
    end
  end

  def accurate_title
    store = @store || current_store
    return super unless params[:action] == 'show'
    if store == domain_store
      store.title
    else
      "#{store.title} - #{domain_store.title}"
    end
  end

  private

  def render_404
    render :file => "#{Rails.root.to_s}/public/404.html",  :status => 404
  end

end
