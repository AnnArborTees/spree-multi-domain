Spree::ProductsController.class_eval do
  before_filter :can_show_product, only: [:show, :analytics_click]
  before_filter :assign_current_store_from_search, only: :index

  def analytics_click
    @product = Spree::Product.friendly.find(params[:id])
    respond_to :js
  end

  def accurate_title
    return super unless params[:action] == 'show'
    if @taxon
      "#{@product.name} - #{@taxon.name} - #{current_store.seo_title}"
    else
      "#{@product.name} - #{current_store.seo_title}"
    end
  end

  private

  def can_show_product
    @product ||= Spree::Product.friendly.find(params[:id])
    if @product.stores.empty? || ( current_store.respond_to?('contains_any_of?') ? 
    		                            !current_store.contains_any_of?(@product.stores) : 
                                    !@product.stores.include?(current_store) )
      raise ActiveRecord::RecordNotFound
    end
  end

  def assign_current_store_from_search
    if params[:store]
      @current_store = Spree::Store.find_by(slug: params[:store])
      raise ActiveRecord::RecordNotFound if @current_store.nil?

      @last_searched_store = @current_store.slug
      add_current_store_id_to_params
    end
  end

end
