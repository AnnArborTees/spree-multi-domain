Deface::Override.new(
  virtual_path: 'spree/shared/_products',
  name: 'products_list_image_link',
  replace: "[data-hook='products_list_item'] > .product-image > erb",
  text: "<%= link_to small_image(product, itemprop: 'image'), url, itemprop: 'url', remote: true %>",
  disabled: true
)

Deface::Override.new(
  virtual_path: 'spree/shared/_products',
  name: 'products_list_text_link',
  replace: "[data-hook='products_list_item'] > erb",
  text: '',
  disabled: true
)
