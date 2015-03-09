Deface::Override.new(
  virtual_path: 'spree/admin/products/_autocomplete',
  name: 'product_sort_image_size',
  add_to_attributes: 'img',
  attributes: { class: 'product-grid-image' }
)
