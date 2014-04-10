Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name:         "Add stores selector to products/new",
    insert_after: ".alpha.four.columns:last-child",
    partial: "spree/admin/products/stores"
)
