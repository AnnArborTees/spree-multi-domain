require 'spec_helper'

describe Spree::Tracker do
  let!(:store) { create :store, slug: 'whatever' }
  let!(:another_store) { create :store, domains: 'completely-different-store.com' }
  let(:other_store) { create :store, domains: 'not-even-relevant.com' }
  let!(:tracker) { create :tracker, store: store }
  let!(:tracker2) { create :tracker, store: another_store }
  let!(:master_tracker) { create :tracker, store: nil }

  describe 'Validations' do
    it 'only allows one master tracker (nil store_id)', story_429: true do
      expect(Spree::Tracker.new(store: nil)).to_not be_valid
      expect(Spree::Tracker.new(store: store)).to be_valid
    end
  end

  describe '.master', story_429: true do
    it 'returns the tracker without a store' do
      expect(Spree::Tracker.master).to eq master_tracker
    end
  end

  describe '#current' do
    it 'should pull out the current tracker' do
      expect(Spree::Tracker.current('www.example.com')).to eq tracker
    end
  end
end
