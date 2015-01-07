require 'spec_helper'

describe 'Parent stores', story_319: true do
  let!(:shop) { create :store, default: true, slug: 'shop', domains: 'shop.test.com' }
  let!(:fandom) { create :store, parent: shop, slug: 'fandom', domains: 'fan.test.com' }
  let!(:starkid) { create :store, parent: fandom, slug: 'starkid', domains: 'starkid.test.com' }

  let!(:a1) { create :product, name: 'A1', stores: [shop] }
  let!(:a2) { create :product, name: 'A2', stores: [fandom] }
  let!(:a3) { create :product, name: 'A3', stores: [starkid] }

  let!(:b1) { create :product, name: 'B1', stores: [shop] }
  let!(:b3) { create :product, name: 'B3', stores: [starkid] }

  context 'http://shop.test.com' do
    before :each do
      'http://shop.test.com'
    end

    context 'visiting shop.test.com' do
      scenario 'I see products in shop + shop children' do
        visit 'shop.test.com'
        %w[A1 A2 A3 B1 B3].each { |it| expect(page).to have_content(it) }
      end

      scenario 'searching for "A", I see "A" products in shop + shop children' do
        visit 'shop.test.com/products?keywords=A'
        %w[A1 A2 A3].each { |it| expect(page).to have_content(it) }
        %w[B1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end

    context 'visiting shop.test.com/stores/fandom' do
      scenario 'I see products in fandom + fandom children' do
        visit 'shop.test.com/stores/fandom'
        %w[A2 A3 B3].each { |it| expect(page).to have_content(it) }
        expect(page).to_not have_content('A1')
      end

      scenario 'searching for "A", I see "A" products in fandom + fandom children' do
        visit 'shop.test.com/products?keywords=A&store=fandom'
        %w[A2 A3].each { |it| expect(page).to have_content(it) }
        %w[A1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end

    context 'visiting shop.test.com/stores/starkid' do
      scenario 'I see products in starkid' do
        visit 'shop.test.com/stores/starkid'
        %w[A3 B3].each { |it| expect(page).to have_content(it) }
        %w[A1 A2 B1].each { |it| expect(page).to_not have_content(it) }
      end

      scenario 'searching for "A", I see "A" products in starkid' do
        visit 'shop.test.com/products?keywords=A&store=starkid'
        expect(page).to have_content 'A1'
        %w[A2 A3 B1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end
  end

  context 'fan.test.com' do
    before :each do
      Capybara.default_host = 'http://fan.test.com'
    end

    context 'visiting fan.test.com' do
      scenario 'I see products in fandom + fandom children' do
        visit 'fan.test.com'
        %w[A2 A3 B3].each { |it| expect(page).to have_content(it) }
        expect(page).to_not have_content('A1')
      end

      scenario 'searching for "A", I see "A" products in fandom + fandom children' do
        visit 'fan.test.com/products?keywords=A'
        %w[A2 A3].each { |it| expect(page).to have_content(it) }
        %w[A1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end

    context 'visiting fan.test.com/stores/starkid' do
      scenario 'I see products in fandom and starkid' do
        visit 'fan.test.com/stores/starkid'
        %w[A2 A3 B3].each { |it| expect(page).to have_content(it) }
        %w[A1 B1].each { |it| expect(page).to_not have_content(it) }
      end

      scenario 'searching for "A", I see "A" products in fandom and starkid' do
        visit 'fan.test.com/products?keywords=A&store=starkid'
        %w[A2 A3].each { |it| expect(page).to have_content(it) }
        %w[A1 B1 B3].each { |it| expect(page).to_not have_content(it) }
      end
    end
  end
end
