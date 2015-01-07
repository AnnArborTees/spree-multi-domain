Spree::ProductsController.class_eval do
  include Spree::TitleFromCurrentStore

  before_filter :can_show_product, only: :show
  before_filter :assign_current_store_from_search, only: :index

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
