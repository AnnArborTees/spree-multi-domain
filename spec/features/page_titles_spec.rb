require 'spec_helper'

feature 'Page titles', story_336: true do
  let(:taxon) { create :taxon, name: 'The Taxon' }
  let(:store) do
    create :store,
      name: 'the store',
      code: 'the-store',
      seo_title: 'This is The Store',
      taxonomies: [taxon.taxonomy],
      domains: 'example.com'
  end
  let(:substore) do
    create :store,
      name: 'under store',
      code: 'sub-store',
      seo_title: 'This is SubStore',
      taxonomies: [taxon.taxonomy],
      parent: store
  end
  let(:product) { create :product, name: 'THE Product', taxons: [taxon], stores: [store] }

  before :each do
    allow_any_instance_of(Spree::StoreController).to receive(:domain_store).and_return store
  end

  describe 'product pages' do
    context 'when there is a taxon' do
      scenario 'have a page title of <ProductName - TaxonName - StoreSeoTitle>' do
        visit spree.product_path(product, taxon_id: taxon.id)
        expect(page).to have_title 'THE Product - The Taxon - This is The Store'
      end
    end

    context 'when there is no taxon' do
      scenario 'have a page title of <ProductName - StoreSeoTitle>' do
        visit spree.product_path(product)
        expect(page).to have_title 'THE Product - This is The Store'
      end
    end
  end

  describe 'taxon pages' do
    scenario 'have a page title of <TaxonName - StoreSeoTitle>' do
      visit spree.nested_taxons_path(taxon)
      expect(page).to have_title 'The Taxon - This is The Store'
    end
  end

  describe 'child store pages' do
    scenario 'have a page title of <ChildStoreSeoTitle - DomainStoreSeoTitle>' do
      visit spree.store_path(substore)
      expect(page).to have_title 'This is SubStore - This is The Store'
    end
  end

  describe 'the home page' do
    scenario 'has a page title of <DomainStoreSeoTitle>' do
      visit spree.root_path
      expect(page).to have_title 'This is The Store'
    end
  end
end
