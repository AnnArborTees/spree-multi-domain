require 'spec_helper'

feature 'With multi-domain stores' do
  
  let!(:admin_role) {create(:admin_role)}
  let!(:user)       {create(:user)}
  let!(:admin_user) {create(:admin_user)}

  let!(:shipping_category) {create(:shipping_category)}
  let!(:default_store)     {create(:default_store)}

  let!(:product_in_test)  {
    create(:product_in_test,  
      shipping_category: shipping_category,
      stores: [default_store])
  }

  context 'as an admin with valid credentials, I can', admin: true, pending: true do
    
    before(:each) do 
      #sign_in_as! admin_user, 'spree123'
    end

    scenario 'create a new store', js: false do
      visit '/admin'
      click_link 'Configuration'
      click_link 'Stores & Domains'
      click_link 'New Store'
      fill_in 'Name', with: 'Test Store'
      fill_in 'Code', with: 'test'
      expect(page).to have_selector('#store_email')
      fill_in 'store[email]', with: 'spree@example.com'
      fill_in 'Default Currency', with: 'USD'
      fill_in 'Domains', with: '127.0.0.1'
      click_button 'Create'
    end

    scenario 'edit a store', js: false, wip: false do
      visit '/admin'
      click_link 'Configuration'
      click_link 'Stores & Domains'
      expect(page).to have_selector('tbody > tr#spree_store_1')
      expect(page).to have_selector('td', text: 'Test Store')
      find('a[data-action="edit"]').click

      fill_in 'Name', with: 'Altered'
      click_button 'Update'

      expect(page).to have_selector('td', text: 'Altered')
    end

    scenario 'delete a store', js: true, wip: false do
      visit '/admin'
      click_link 'Configuration'
      click_link 'Stores & Domains'
      expect(page).to have_selector('tbody > tr#spree_store_1')
      expect(page).to have_selector('td', text: 'Test Store')
      find('a[data-action="remove"]').click

      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_selector('tbody > tr#spree_store_1')
    end

    scenario 'create a product in a store', js: true, wip: false do
      visit '/admin'
      click_link 'Products'
      click_link 'New Product'
      fill_in 'Name', with: 'Test Product'
      fill_in 'Master Price', with: '99.99'
      select 'Default', from: 'Shipping Categories'
      select 'Test Store', from: 'product_store_ids'
      click_button 'Create'
      expect(page).to have_selector('h1.page-title', text: 'Editing Product “Test Product”')
      expect(page).to have_selector('select#product_store_ids')
      expect(page).to have_selector('.select2-search-choice > div', text: 'Test Store')
    end

  end

end
