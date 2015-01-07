require 'spec_helper'

feature 'With homepage slides' do
  stub_authorization!

  context 'as an admin with valid credentials, I can', admin: true, pending: false do

    let!(:shipping_category) {create(:shipping_category, name: 'Default')}
    let!(:default_store)     {create(:default_store)}

    let!(:product_in_test)  {
      create(:product_in_test,
             shipping_category: shipping_category,
             stores: [default_store])
    }

    scenario 'create a new homepage slide', js: false, wip: false, pending: 'TODO disable sunspot for this' do
      visit '/admin'
      click_link 'Configuration'
      click_link 'Homepage Slides'
      click_link 'New Homepage Slide'
      fill_in 'Name', with: 'Test Slide'
      fill_in 'Description', with: 'Test Description'
      fill_in 'Label', with: 'Test Label Text'
      fill_in 'Text', with: 'Test Text'
      click_button 'Create'
    end
  end
end
