Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "multi_domain_admin_configurations_menu",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :text => "<%= configurations_sidebar_menu_item Spree.t(:stores_admin), admin_stores_url %>",
                     :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "homepage_slide_admin_configurations_menu",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :text => "<%= configurations_sidebar_menu_item Spree.t(:homepage_slides_admin), admin_homepage_slides_url %>",
                     :disabled => false)
