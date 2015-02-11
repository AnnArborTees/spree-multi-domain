Spree::ProductsController.class_eval do
  before_filter :assign_current_store_from_url, only: :show
  before_filter :can_show_product, only: [:show, :analytics_click]
  before_filter :assign_current_store_from_search, only: :index

  def analytics_click
    @product = Spree::Product.friendly.find(params[:id])
    respond_to :js
  end

  def accurate_title
    return super unless params[:action] == 'show'
    if @taxon
      "#{@product.name} - #{@taxon.name} - #{current_store.title}"
    else
      "#{@product.name} - #{current_store.title}"
    end
  end

  private

  def can_show_product
    @product ||= Spree::Product.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound if @product.stores.empty?

    unless @product.stores.include?(current_store) ||
           @product.stores.include?(domain_store) ||
           (@product.stores - domain_store.all_children).length < @product.stores.length

      # If we do a broad search, and click on a product that belongs
      # to the current store's children but NOT the current store,
      # then we want to set the current substore to one of the
      # product's stores.
      store_is_in_hirearchy = false
      @product.stores.find_each do |product_store|
        difference = product_store.up_to(current_store)
        next if difference.empty?

        add_store_id_to_params(product_store)
        store_is_in_hirearchy = true
        break
      end

      raise ActiveRecord::RecordNotFound unless store_is_in_hirearchy
    end
  end

  def assign_current_store_from_url
    return unless params[:store_id]
    @current_store = Spree::Store.find(params[:store_id])
  end

  def assign_current_store_from_search
    if params[:keywords] && !params[:store]
      @current_store = domain_store
    elsif params[:store]
      @current_store = Spree::Store.find_by(slug: params[:store])
      raise ActiveRecord::RecordNotFound if @current_store.nil?

      @last_searched_store = @current_store.slug
      add_current_store_id_to_params
    end
  end

end
