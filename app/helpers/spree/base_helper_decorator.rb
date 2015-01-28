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
        trackers += @order.trackers if @order
        trackers.uniq
      end
    end

    def analytics_js
      "//www.google-analytics.com/analytics#{'_debug' unless Rails.env.production?}.js"
    end

    def ga_method(tracker, method)
      tracker.master? ? method : "#{tracker.analytics_name}.#{method}"
    end

    def ga_create(tracker)
      name_obj = tracker.master? ? 'null' : "{'name': '#{tracker.analytics_name}'}"
      "aatc_ga('create', '#{tracker.analytics_id}', 'auto', #{name_obj});".html_safe
    end

    def ga_require(tracker, plugin)
      "aatc_ga('#{ga_method(tracker, 'require')}', '#{plugin}');".html_safe
    end

    def ga_send_pageview(tracker)
      "aatc_ga('#{ga_method(tracker, 'send')}', 'pageview');".html_safe
    end

    def ec_list
      # TODO
      'homepage'
    end

    def ga_ec_add_impression(tracker, product, position)
%<aatc_ga('#{ga_method(tracker, 'ec:addImpression')}', {
  'id': '#{product.id}',
  'name': '#{product.name.gsub("'", "\\\\'")}',
  'type': 'view',
  'category': '#{product.try(:analytics_category) || 'null'}',
  'brand': '#{product.try(:analytics_brand) || 'null'}',
  'list': '#{ec_list}',
  'position': #{position},
});>
        .html_safe
    end
  end
end
