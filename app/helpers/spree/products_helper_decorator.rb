module Spree
  module Api
    ProductsHelper.class_eval do
      def get_taxonomies
        @taxonomies ||= current_store.present? ? current_store.taxonomies : Spree::Taxonomy
        @taxonomies = @taxonomies.includes(:root => :children)
        @taxonomies
      end
    end
  end
end