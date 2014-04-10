module Spree
  BaseHelper.class_eval do
  	def store_home_path
	    if current_store.default
	      spree.root_path
	    else
	      "/stores/#{current_store.code}"
	    end
	  end
  	
    def logo(image_path=Spree::Config[:logo])
    	link_to image_tag(image_path), store_home_path
    end
  end
end