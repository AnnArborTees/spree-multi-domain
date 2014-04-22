require 'spec_helper'

# TODO clean this up holy cow

feature 'Store mixing:' do
  
  let!(:admin_role) {create(:admin_role)}
  let!(:user) {create(:user)}

  let!(:shipping_category) {create(:shipping_category)}
  let!(:default_store) {create(:default_store)}

  let!(:product_in_test)  {
    create(:product_in_test,  
      shipping_category: shipping_category,
      stores: [default_store])
  }

  context 'as a user visiting the site', user: true do
  
    let!(:alternative_store) {create(:alternative_store)}
    let!(:sub_store) {create(:sub_store)}

    let!(:product_in_other) {
      create(:product_in_other,
        shipping_category: shipping_category,
        stores: [alternative_store])
    }
    let!(:product_in_other_and_sub) {
      create(:product,
        name: 'Other + Sub',
        slug: 'otherandsub',
        shipping_category: shipping_category,
        stores: [alternative_store, sub_store])
    }
    let!(:product_in_sub) {
      create(:product,
        name: 'Product in Sub',
        slug: 'sub-only',
        shipping_category: shipping_category,
        stores: [sub_store])
    }

    scenario 'I can visit the homepage, then stores index, then a specific store, and see the correct products' do
      visit '/'
      visit '/stores'
      visit '/stores/other'
      expect(page).to display_product_called 'Product in Other'
      expect(page).to_not display_product_called 'Product in Test'
    end

    scenario 'I can view product details, and the home buttons will lead back to the store home', wip: true, js: true do
      visit '/stores/other'
      find('a', text: "Product in Other").click
      # visit '/products/other-product'
      expect(page).to have_content 'Home'
      expect(page).to have_selector 'a[href="/stores/other"]'
    end

    scenario 'I can see the products in the default store', wip: false do
      visit '/'
      expect(page).to have_selector('a.info[itemprop=name]', text: 'Product in Test')
    end

    scenario 'I can visit the default store explicitly, and NOT be redirected to root' do
      visit '/stores/test'
      expect(current_path).to_not eq '/'
    end

    context 'with a store matching the current domain, I', user: true do
      let!(:domained_store) {create(:domained_store)}
      let!(:product_in_domain) {
        create(:product_in_domain, 
          shipping_category: shipping_category,
          stores: [domained_store])
      }

      scenario "can see the alternate store when visiting '/'", wip: false, pending: false do
        visit '/'
        expect(page).to     display_product_called 'Product in Domained'
        expect(page).to_not display_product_called 'Product in Test'
      end

    end



    scenario 'I can visit a valid compound store url and see only the mutually-included products', wip: false do
      visit '/stores/other/sub'
      expect(page).to display_product_called 'Other + Sub'
      expect(page).to_not display_product_called 'Product in Sub'
      expect(page).to_not display_product_called 'Product in Other'
      expect(page).to_not display_product_called 'Product in Test'
    end

    scenario 'visiting an invalid compound store url redirects to an error page', wip: false do
      visit '/stores/sub/other'
      # TODO Change this to actually look for error page content
      expect(page).to_not display_product_called 'Product in Sub'
      expect(page).to_not display_product_called 'Product in Other'
    end

    scenario 'two stores of the same url index cannot be mixed', wip: false do
      visit '/stores/test/other'
      # TODO Change this to actually look for error page content
      expect(page).to_not display_product_called 'Product in Other'
      expect(page).to_not display_product_called 'Product in Test'
    end

    context 'when alternative_store is under the domain www.example.com,' do
      before(:each) { alternative_store.domains = 'www.example.com'; alternative_store.save }

      scenario 'I am redirected to /stores/sub when visiting /stores/other/sub', wip: false do
        visit '/stores/other/sub'
        expect(current_path).to eq '/stores/sub'
        expect(page).to_not display_product_called 'Product in Sub'
        expect(page).to_not display_product_called 'Product in Other'
        expect(page).to_not display_product_called 'Product in Test'
      end

    end

  end

end