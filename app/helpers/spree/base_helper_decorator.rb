module Spree
  BaseHelper.class_eval do
    def store_home_path
      domain = try(:current_domain)
      if domain
        use_root_path = current_store.matches_domain?(domain)
      else
        use_root_path = false
      end

      if use_root_path
        spree.root_path
      else
        spree.store_path(current_store.slug)
      end
    end

    def logo(image_path=Spree::Config[:logo])
      link_to image_tag(image_path), store_home_path
    end

    def breadcrumbs(taxon, separator="&nbsp;&raquo;&nbsp;")
      return "" if current_page?("/") || taxon.nil?
      separator = raw(separator)
      crumbs = [content_tag(:li, link_to(Spree.t(:home), store_home_path) + separator)]
      if taxon
        crumbs << content_tag(:li, link_to(Spree.t(:products), products_path) + separator)
        crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + separator) } unless taxon.ancestors.empty?
        crumbs << content_tag(:li, content_tag(:span, link_to(taxon.name , seo_url(taxon))))
      else
        crumbs << content_tag(:li, content_tag(:span, Spree.t(:products)))
      end
      crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), class: 'inline')
      content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'sixteen columns')
    end

    def true_false_yes_no(bool)
      bool ? 'Yes'  : 'No'
    end

    def relevant_trackers
      @relevant_trackers ||= begin
        trackers = [Spree::Tracker.master].compact
        trackers += current_store.trackers

        if session[:order_id]
          order = Spree::Order.find(session[:order_id])
        else
          order = @order
        end
        trackers += order.trackers if order

        trackers.uniq
      end
    end

    def analytics_js
      "//www.google-analytics.com/analytics#{'_debug' unless Rails.env.production?}.js"
    end

    def ec_list
      if params[:controller] == 'spree/home'
        return 'Homepage'
      end
      if params[:controller] == 'spree/stores'
        return 'Store Page'
      end
      if params[:controller] == 'spree/products' && params[:action] == 'index'
        return 'Search Results'
      end
      if params[:controller] == 'spree/order'
        return 'Cart'
      end
      # 'Product View'
    end

    def ga_ec_product(product, position = 1, additional = {})
      { id: product.id.to_s,
        name: product.name,
        category: product.try(:analytics_category),
        brand: product.try(:analytics_brand),
        list: ec_list,
        position: position,
        price: product.price.to_s
      }
        .merge(additional)
        .merge(additional_ga_ec_product_fields(product))
        .to_json
        .html_safe
    end
    # Override this to add additional (or change) default fields
    def additional_ga_ec_product_fields(_product)
      {}
    end

    def ga_ec_purchase(order, store)
      { id: order.number,
        affiliation: store.name,
        revenue: order.total,
        tax: order.included_tax_total + order.additional_tax_total,
        shipping: order.ship_total
      }
        .to_json
        .html_safe
    end

    def order_just_completed?
      params[:checkout_complete]
    end

  end
end
