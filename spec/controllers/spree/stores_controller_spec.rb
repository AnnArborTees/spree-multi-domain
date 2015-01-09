require 'spec_helper'

describe Spree::StoresController do
  
  describe 'on :show to a valid store' do
    let!(:store) { FactoryGirl.create(:store, seo_title: 'totally rad') }

    context 'when given a slug', story_319: true do
      it 'should return 200' do
        spree_get :show, id: store.slug
        expect(response.response_code).to eq 200
      end
    end

    context 'when given an id', story_319: true do
      it 'redirects to the slug' do
        spree_get :show, id: store.id
        expect(response).to redirect_to "/stores/#{store.slug}"
      end
    end
  end

  describe 'on :show with 2 mutually populated stores', pending: 'EL DEPRECATIO' do
    let!(:store1) { FactoryGirl.create(:store,
            name: 'Store 1',
            code: 'store1') }
    let!(:store2) { FactoryGirl.create(:store,
            name: 'Store 2',
            code: 'store2') }

    let!(:product1) { FactoryGirl.create(:product,
            name: 'Product 1',
            slug: 'product1',
            stores: [store1, store2]) }
    let!(:product2) { FactoryGirl.create(:product,
            name: 'Product 2',
            slug: 'product2',
            stores: [store1, store2]) }

    it 'mixed in correct order, should return 200' do
      spree_get :show, store_codes: 'store1/store2'
      expect(response.response_code).to eq 200
    end

    it 'mixed out of order, should return 404' do
      spree_get :show, store_codes: 'store2/store1'
      expect(response.response_code).to eq 404
    end
  end

end
