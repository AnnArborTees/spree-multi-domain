require 'spec_helper'

include Spree::Core::ControllerHelpers::Search

describe Spree::Product do

  let!(:store) { create(:store) }
  let!(:product) { create :product, name: 'first prod', stores: [store] }
  let!(:product2) { create :product, name: 'second prod', slug: 'something else' }

  it 'should correctly find products by store' do
    products_by_store = Spree::Product.by_store(store)

    products_by_store.should include(product)
    products_by_store.should_not include(product2)
  end

  it { is_expected.to have_searchable_field :safe_name }
  it { is_expected.to have_searchable_field :store_ids }

  context 'search', search: true do
    let!(:try_spree_current_user) { create :user }
    let!(:current_currency) { 'USD' }

    it 'is a sunspot search' do
      searcher = build_searcher({ store_id: store.id })
      expect(searcher).to respond_to :solr_search
    end
  end

end
