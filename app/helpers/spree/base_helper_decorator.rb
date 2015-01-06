module Spree
  BaseHelper.class_eval do
    def store_home_path
      if current_store.matches_domain?
        spree.root_path
      else
        "/stores/#{current_store.path}"
      end
    end

    def logo(image_path=Spree::Config[:logo])
      link_to image_tag(image_path), store_home_path
    end

    def true_false_yes_no(bool)
      bool ? 'Yes'  : 'No'
    end
  end
end
