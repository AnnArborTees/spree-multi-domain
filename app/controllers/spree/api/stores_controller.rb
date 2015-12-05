module Spree
  module Api
    class StoresController < Spree::Api::BaseController

      def index
        @stores = Spree::Store.all.order(:name)
        respond_with @stores
      end

      def show
        @store = Spree::Store.find(params[:id])
        respond_with(@store)
      end

    end
  end
end
