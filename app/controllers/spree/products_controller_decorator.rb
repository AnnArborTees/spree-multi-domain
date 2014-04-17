Spree::ProductsController.class_eval do

  before_filter :can_show_product, :only => :show

  private

  def can_show_product
    @product ||= Spree::Product.friendly.find(params[:id])
    if @product.stores.empty? || !current_store.contains_any_of?(@product.stores)
      raise ActiveRecord::RecordNotFound
    end
  end

end
