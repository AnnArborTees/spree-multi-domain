require 'spec_helper'

describe Spree::BaseHelper do
  context 'Given a current_store, product, and order', story_429: true do
    let!(:current_store) { create :store, code: 'the-current' }
    let!(:other_store) { create :store, code: 'other' }
    let!(:product) { create :product, stores: [current_store] }
    let!(:order) { create :order_with_line_items }

    let!(:master_tracker) { create :tracker, store_id: nil }
    let!(:current_store_tracker) { create :tracker, store: current_store }
    let!(:other_store_tracker) { create :tracker, store: other_store }

    before :each do
      allow(helper).to receive(:current_store).and_return current_store
      helper.instance_variable_set(:@product, product)
      session[:order_id] = order.id

      order.line_items[0..2].each do |line_item|
        line_item.store = current_store
      end
      order.line_items[3..-1].each do |line_item|
        line_item.store = other_store
      end
    end

    describe '#relevant_trackers' do
      it 'returns master tracker, current_store trackers, and order trackers' do
        expect(
          helper.relevant_trackers - [master_tracker, current_store_tracker, other_store_tracker]
        )
          .to be_empty
      end
    end

    describe '#analytics_js' do
      context 'in production' do
        before :each do
          allow(Rails.env).to receive(:production?).and_return true
        end

        it 'gives us analytics.js' do
          expect(helper.analytics_js).to include 'analytics.js'
        end
      end

      context 'in development' do
        before :each do
          allow(Rails.env).to receive(:production?).and_return false
        end

        it 'gives us analytics_debug.js' do
          expect(helper.analytics_js).to include 'analytics_debug.js'
        end
      end
    end

    describe '#ga_create', pending: 'no longer in use' do
      context 'given a tracker' do
        it 'returns a valid javascript call to aatc_ga with the trackers analytics name' do
          expect(helper.ga_create(current_store_tracker))
            .to include "{'name': 'the_current'}"
        end
      end
    end

    describe '#ga_send_pageview', pending: 'no longer in use' do
      context 'given a tracker' do
        it 'returns a valid javascript call to aatc_ga with tracker name.send' do
          expect(helper.ga_send_pageview(current_store_tracker))
            .to include "'the_current.send'"
        end
      end
    end

    describe '#ec_list', ec_list: true do
      let(:spree_home_index) do
        { controller: 'spree/home',
          action: 'index'
        }.with_indifferent_access
      end
      let(:spree_products_index) do
        { controller: 'spree/products',
          action: 'index'
        }.with_indifferent_access
      end
      subject { helper.ec_list }

      context 'when params == { action: "index", controller: "spree/home" }' do
        before { allow(helper).to receive(:params).and_return spree_home_index }
        it { is_expected.to eq 'Homepage' }
      end

      context 'when params == { action: "index", controller: "spree/products" }' do
        before { allow(helper).to receive(:params).and_return spree_products_index }
        it { is_expected.to eq 'Search Results' }
      end
    end

    describe '#ga_ec_product' do
      context 'given a product and a position' do
        it 'returns a valid js object with appropriate attributes' do
          allow(product).to receive(:analytics_category).and_return 'Apparel/T-Shirts'
          allow(product).to receive(:analytics_brand).and_return 'Ann Arbor Tees'
          allow(helper).to receive(:ec_list).and_return 'Homepage'

          result = helper.ga_ec_product(product, 1)
          expect(result).to include %({)
          expect(result).to include %("id":"#{product.id}")
          expect(result).to include %("name":"#{product.name}")
          # expect(result).to include %("type":"view")
          expect(result).to include %("category":"Apparel/T-Shirts")
          expect(result).to include %("brand":"Ann Arbor Tees")
          expect(result).to include %("list":"Homepage")
          expect(result).to include %("position":1)
          expect(result).to include %("price":"#{product.price}")
          expect(result).to include %(})
        end
      end
    end
  end
end
