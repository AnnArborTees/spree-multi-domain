module Spree
  module Api
    class StoresController < Spree::Api::BaseController

      def index
        @stores = Spree::Store.all
        respond_with @stores
      end

    end
  end
end
