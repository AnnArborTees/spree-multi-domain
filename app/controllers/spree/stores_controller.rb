class Spree::StoresController < Spree::StoreController
  helper 'spree/products'

  def index
    @stores = Spree::Store.all
  end

  def show
    if /^\d+$/ =~ params[:id]
      @store = Spree::Store.find_by(id: params[:id])
      return render_404 if @store.nil?
      return redirect_to spree.store_path(@store.slug)
    end

    @store = @current_store = Spree::Store.find_by(slug: params[:id])

    return render_404 if @store.nil?

    add_current_store_id_to_params

    @searcher = build_searcher(params)
    @products = @searcher.retrieve_products
    @taxonomies = @store.taxonomies.includes(root: :children)

    render 'spree/home/index'
  end

  def accurate_title
    return super unless params[:action] == 'show'
    if @store == domain_store
      @store.seo_title
    else
      "#{@store.seo_title} - #{domain_store.seo_title}"
    end
  end

  private

  def render_404
    render :file => "#{Rails.root.to_s}/public/404.html",  :status => 404
  end

end
