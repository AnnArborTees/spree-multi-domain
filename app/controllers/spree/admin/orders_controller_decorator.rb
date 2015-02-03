Spree::Admin::OrdersController.class_eval do

  def cancel
    @order.cancel!
    flash[:success] = Spree.t(:order_canceled)
    redirect_to :back, just_cancelled_order: true
  end

end
