module Spree
  module TitleFromCurrentStore
    extend ActiveSupport::Concern

    def accurate_title
      current_store.try(:seo_title)
    end
  end
end
