Deface::Override.new(
  virtual_path: 'spree/products/index',
  name: 'products_empty_search_results_create_your_own',
  insert_bottom: '[data-hook="search_results"]',
  partial: 'spree/products/create_your_own'
)
