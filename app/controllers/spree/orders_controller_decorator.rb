Spree::OrdersController.class_eval do
  # Copy/paste of actual orders controller.
  def populate
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)

    if populator.populate(params[:variant_id], params[:quantity])
      respond_with(@order) do |format|
        format.html { redirect_to cart_path }
      end
      # Except for these two line
      store = session_store || current_store
      current_order.line_items.last.update_attributes store_id: store.id
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_back_or_default(spree.root_path)
    end
  end
end
