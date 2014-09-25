require 'spec_helper'

module Spree
  describe Spree::Api::StoresController do
    render_views

    before { stub_authentication! }

    context 'as a normal user' do

      let!(:store) { create(:store) }

      it 'retrieves a list of stores'  do
        api_get :index
        expect(json_response['stores'].first).to include( attributes_for(:store).stringify_keys )
      end
    end

  end
end