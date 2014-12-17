module Spree
  module Admin
    class HomepagesController < ResourceController
      update.before :set_products

      def index
      end

      private

      def permitted_homepages_attributes
        [:name, :store_id, :product_ids]
      end

      def set_products
        @homepage.product_ids = nil unless params[:homepage].key? :product_ids
        params[:homepage][:product_ids] = params[:homepage][:product_ids].split(',') if params[:homepage].key? :product_ids
      end
    end
  end
end