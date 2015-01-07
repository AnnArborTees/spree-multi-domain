require 'spec_helper'

module Spree
  describe Spree::Api::StoresController do
    render_views

    before { stub_authentication! }

    context 'as a normal user' do

      let!(:store) { create(:store, slug: 'theslug') }

      describe '#index' do
        it 'retrieves a list of stores'  do
          api_get :index
          expect(JSON.parse(store.to_json).stringify_keys).to include json_response['stores'].first
        end
      end

      describe '#show' do
        it 'retrieves a store'  do
          api_get :show, :id => store.to_param
          expect(json_response).to include()
          expect(JSON.parse(store.to_json).stringify_keys).to include json_response
        end
      end
    end

  end
end
