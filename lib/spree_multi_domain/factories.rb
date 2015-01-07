FactoryGirl.define do
  factory :store, :class => Spree::Store do
    name 'My store'
    code 'my_store'
    email 'example@example.com'
    domains 'www.example.com' # makes life simple, this is the default
    # integration session domain
  end
end

# Begin added stuff
# TODO clean this uppppp
FactoryGirl.define do
  factory :product_in_test, class: Spree::Product do
    name 'Product in Test'
    available_on Time.now
    slug 'test-product'
    price 1.20
  end

  factory :product_in_other, class: Spree::Product do
    name 'Product in Other'
    available_on Time.now
    slug 'other-product'
    price 1.50
  end

  factory :basic_product, class: Spree::Product do
    available_on Time.now
    price 99.99
  end

  factory :product_in_domain, class: Spree::Product do
    name 'Product in Domained'
    available_on Time.now
    slug 'domained-product'
    price 1.50
  end
end


FactoryGirl.define do
  factory :basic_shipping_category, class: Spree::ShippingCategory do
    name 'Default'
  end
end

FactoryGirl.define do
  factory :default_store, class: Spree::Store do
    name 'Test Store'
    code 'test'
    domains 'test.aatc.com'
    default 1
    email '...'
    default_currency 'USD'
  end

  factory :alternative_store, class: Spree::Store do
    name 'Other Store'
    code 'other'
    domains 'dont.care.com'
    default 0
    email '...'
    default_currency 'USD'
  end

  factory :sub_store, class: Spree::Store do
    name 'Sub Store'
    code 'sub'
    domains 'whatever.com'
    default 0
    email '...'
    default_currency 'USD'
  end

  factory :domained_store, class: Spree::Store do
    name 'Domained Store'
    code 'dom'
    domains 'www.example.com'
    default 0
    email '...'
    default_currency 'USD'
  end
end
