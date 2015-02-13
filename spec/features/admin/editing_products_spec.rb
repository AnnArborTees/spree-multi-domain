require 'spec_helper'

feature 'when editing products,', story_434: true do
  stub_authorization!

  let!(:shipping_category) { create(:shipping_category, name: 'Default') }
  let!(:taxon1) { create :taxon, name: 'Taxon One' }
  let!(:taxon2) { create :taxon, name: 'Taxon Two' }
  let!(:store_with_both_taxons) { create :store, code: 'anytaxon' }
  let!(:store_with_t1) { create :store, code: 'tax1' }
  let!(:store_with_t2) { create :store, code: 'tax2' }
  let!(:product) { create(:product, name: 'Test Product', stores: [store_with_t2]) }

  scenario 'taxons are scoped by store', js: true do
    visit '/admin'
    click_link 'Products'
    first('[data-action=edit]').click

    find('#s2id_product_taxon_ids input').click
    sleep 0.5
    expect(all('.select2-results > li').length).to eq 1
    expect(page).to have_css '.select2-result-label', text: 'Taxon Two'
    expect(page).to_not have_css '.select2-result-label', text: 'Taxon One'
  end
end
