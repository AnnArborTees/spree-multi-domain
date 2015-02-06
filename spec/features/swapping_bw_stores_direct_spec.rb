require "spec_helper"

feature "swappin' betwix storz", story_439: true do
  let!(:default_store) {create :store, default: true, domains: '127.0.0.1', slug: "default"}
  let!(:store1) {create :store, parent: default_store, slug: "slug1"}
  let!(:store2) {create :store, parent: default_store, slug: "slug2"}

  let!(:product1) {create :product, stores: [store1]}
  let!(:product2) {create :product, stores: [store2]}

  scenario "visiting a store picking a product visit another store", js: true do
    Rails.application.config.spree.preferences.searcher_class = Spree::Core::Search::Base

    visit spree.store_path(store1.slug)
    click_link product1.name
    visit spree.product_path(product2)
    expect(page).to have_content(product2.name)
  end

end