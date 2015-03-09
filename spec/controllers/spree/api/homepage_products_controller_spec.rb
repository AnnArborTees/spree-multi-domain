require 'spec_helper'

module Spree
  describe Api::HomepageProductsController do
    let(:store) { create :store }
    let(:homepage) do
      create(:homepage, store: store).tap do |homepage|
        3.times do
          create :homepage_product, homepage: homepage, product: create(:product)
        end
      end
    end

    before do
      stub_authentication!
    end

    context 'an admin' do
      sign_in_as_admin!

      it 'can change the ordering of a product', story_346: true do
        last_product = homepage.products.last
        hp = homepage.homepage_products.find_by(product_id: last_product.id)
        expect(hp.position).to eq 3

        api_put :update, homepage_id: homepage.id, product_id: last_product.id, position: 0
        expect(response.status).to eq 200
        expect(hp.reload.position).to eq 1
      end
    end
  end
end
