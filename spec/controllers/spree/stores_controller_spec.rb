require 'spec_helper'

describe Spree::StoresController do
  
  describe 'on :show to a valid store' do
    let!(:store) { FactoryGirl.create(:store, seo_title: 'totally rad') }

    it 'should return 200' do
      spree_get :show, store_codes: store.slug
      expect(response.response_code).to eq 200
    end

    describe 'title', story_334: true do
      context 'when current_store has an seo_title' do
        it 'is current_store.seo_title' do
          spree_get :show, store_codes: store.slug
          expect(controller.send(:title)).to include 'totally rad'
        end
      end
    end
  end

  describe 'on :show with 2 mutually populated stores' do
    let!(:store1) { FactoryGirl.create(:store,
            name: 'Store 1',
            code: 'store1',
            url_index: '0') }
    let!(:store2) { FactoryGirl.create(:store,
            name: 'Store 2',
            code: 'store2',
            url_index: '1') }

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
