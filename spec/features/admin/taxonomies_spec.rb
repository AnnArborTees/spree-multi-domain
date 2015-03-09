require 'spec_helper'

feature 'editing taxonomies', story_435: true do
  stub_authorization!

  let!(:store1) { create :store, code: 'store1', name: 'Store One' }
  let!(:store2) { create :store, code: 'store2', name: 'Store Two' }

  let!(:taxonomy1) { create :taxonomy, name: 'First One', stores: [store1] }
  let!(:taxonomy2) { create :taxonomy, name: 'Second One', stores: [store2, store1] }

  scenario 'the list of taxonomies to edit is scoped by store', js: true do
    pending "The dummy app's html is completely messed up and I cannot test these js things with it."
    visit spree.admin_taxonomies_path

    sleep 0.5
    select 'Store One', from: 'store_select'
    sleep 0.5
    expect(page).to have_css 'td', text: 'First One'
    expect(page).to_not have_css 'td', text: 'Second One'

    select 'Store Two', from: 'store_select'
    sleep 0.5
    expect(page).to have_css 'td', text: 'First One'
    expect(page).to have_css 'td', text: 'Second One'
  end
end
