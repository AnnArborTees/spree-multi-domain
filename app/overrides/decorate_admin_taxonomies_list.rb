Deface::Override.new(
  virtual_path: 'spree/admin/taxonomies/_list',
  name: 'Adding search selecter to taxonomies list',
  insert_before: '#listing_taxonomies',
  text: %(<label>Store</label>: <%= store_select_filter %>)
)
