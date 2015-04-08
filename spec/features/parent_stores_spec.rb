require 'spec_helper'

feature 'Parent stores', story_319: true do
  let!(:shop) { create :store, default: true, slug: 'shop', domains: 'shop.test.com' }
  let!(:fandom) { create :store, parent: shop, slug: 'fandom', domains: 'fan.test.com' }
  let!(:starkid) { create :store, parent: fandom, slug: 'starkid', domains: 'starkid.test.com' }

  let!(:a1) { create :product, slug: 'a1-prod', name: 'A1', stores: [shop] }
  let!(:a2) { create :product, slug: 'a2-prod', name: 'A2', stores: [fandom] }
  let!(:a3) { create :product, slug: 'a3-prod', name: 'A3', stores: [starkid] }

  let!(:b1) { create :product, slug: 'b1-prod', name: 'B1', stores: [shop] }
  let!(:b3) { create :product, slug: 'b3-prod', name: 'B3', stores: [starkid] }

  context 'http://shop.test.com' do
    before :each do
      Capybara.default_host = 'http://shop.test.com'
    end

    context 'visiting shop.test.com' do
      scenario 'the url is correct' do
        visit '/'
        expect(page.current_url).to eq 'http://shop.test.com/'
      end

      scenario 'I see products in shop', go: true do
        visit '/'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, shop.id
          end
        }
        # %w[A1 A2 A3 B1 B3].each { |it| expect(page).to have_content(it) }
      end

      scenario 'searching for "A", I see "A" products in shop + shop children' do
        visit '/products?keywords=A'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, shop.id
            with :store_ids, fandom.id
            with :store_ids, starkid.id
          end
        }
        expect(Sunspot.session).to have_search_params(:keywords, 'A')
        # %w[A1 A2 A3].each { |it| expect(page).to have_content(it) }
        # %w[B1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end

    context 'visiting shop.test.com/s/fandom' do
      scenario 'I see products in fandom' do
        visit '/s/fandom'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, fandom.id
          end
        }
        # %w[A2 A3 B3].each { |it| expect(page).to have_content(it) }
        # expect(page).to_not have_content('A1')
      end

      scenario 'searching for "A", I see "A" products in fandom + fandom children' do
        visit '/products?keywords=A&store=fandom'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, fandom.id
            with :store_ids, starkid.id
          end
        }
        expect(Sunspot.session).to have_search_params(:keywords, 'A')
        # %w[A2 A3].each { |it| expect(page).to have_content(it) }
        # %w[A1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end

    context 'visiting shop.test.com/s/starkid' do
      scenario 'I see products in starkid' do
        visit '/s/starkid'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, starkid.id
          end
        }
        # %w[A3 B3].each { |it| expect(page).to have_content(it) }
        # %w[A1 A2 B1].each { |it| expect(page).to_not have_content(it) }
      end

      scenario 'searching for "A", I see "A" products in starkid' do
        visit '/products?keywords=A&store=starkid'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, starkid.id
          end
        }
        expect(Sunspot.session).to have_search_params(:keywords, 'A')
        # expect(page).to have_content 'A1'
        # %w[A2 A3 B1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end
  end

  context 'fan.test.com' do
    before :each do
      Capybara.default_host = 'http://fan.test.com'
    end

    context 'visiting fan.test.com' do
      scenario 'the url is correct' do
        visit '/'
        expect(page.current_url).to eq 'http://fan.test.com/'
      end

      scenario 'I see products in fandom' do
        visit '/'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, fandom.id
          end
        }
        # %w[A2 A3 B3].each { |it| expect(page).to have_content(it) }
        # expect(page).to_not have_content('A1')
      end

      scenario 'searching for "A", I see "A" products in fandom + fandom children' do
        visit '/products?keywords=A'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, fandom.id
            with :store_ids, starkid.id
          end
        }
        expect(Sunspot.session).to have_search_params(:keywords, 'A')
        # %w[A2 A3].each { |it| expect(page).to have_content(it) }
        # %w[A1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end

    context 'visiting fan.test.com/s/starkid' do
      scenario 'I see products in starkid' do
        visit '/s/starkid'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, starkid.id
          end
        }
        # %w[A2 A3 B3].each { |it| expect(page).to have_content(it) }
        # %w[A1 B1].each { |it| expect(page).to_not have_content(it) }
      end

      scenario 'searching for "A", I see "A" products in starkid' do
        visit '/products?keywords=A&store=starkid'
        expect(Sunspot.session).to be_a_search_for(Spree::Product)
        expect(Sunspot.session).to have_search_params(:with) {
          any_of do
            with :store_ids, starkid.id
          end
        }
        expect(Sunspot.session).to have_search_params(:keywords, 'A')
        # %w[A2 A3].each { |it| expect(page).to have_content(it) }
        # %w[A1 B1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end
  end
end
