Deface::Override.new(
  virtual_path: 'spree/admin/orders/edit',
  name: 'multi_domain_admin_order_analytics_for_cancelation',
  insert_after: "[data-hook='admin_order_edit_form']",
  partial: 'spree/shared/google_analytics_refund'
)
