module Spree
  module Api
    class HomepageProductsController < Spree::Api::BaseController
      def update
        authorize! :update, Product
        authorize! :update, Taxon
        homepage_product = Spree::HomepageProduct.find_by(
          product_id: params[:product_id],
          homepage_id: params[:homepage_id]
        )

        homepage_product.insert_at(params[:position].to_i + 1)
        render nothing: true
      end
    end
  end
end
