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
  end
end
