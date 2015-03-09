module Spree
  module Admin
    class HomepagesController < ResourceController
      update.before :set_products

      def index
        if params[:q]
          @homepages = Homepage.ransack(params[:q]).result
        end

        respond_to do |format|
          format.json do
            render json: @homepages
          end
          format.html do
            render :index
          end
        end
      end

      def search
        if params[:ids]
          @homepages = Homepage.where(id: params[:ids].split(','))
        else
          @homepages = Homepage.limit(20).ransack(params[:q]).result
        end

        render json: @homepages
      end

      def products
        @homepage = Homepage.find(params[:id])
        @products = @homepage.products.to_json(
          include: { master: { include: { images: { methods: [:small_url] } } } }
        )

        render json: @products
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
