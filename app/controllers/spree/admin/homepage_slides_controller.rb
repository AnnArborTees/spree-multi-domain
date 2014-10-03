module Spree
  module Admin
    class HomepageSlidesController < ResourceController
      update.before :set_stores

      def index

      end

      private

      def permitted_homepage_slides_attributes
        [:name, :description, :label, :text, :image, :active]
      end

      def set_stores
        @homepage_slide.store_ids = nil unless params[:homepage_slide].key? :store_ids
      end
    end
  end
end