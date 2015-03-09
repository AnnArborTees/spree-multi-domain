require 'acts_as_list'

module Spree
  class HomepageProduct < ActiveRecord::Base
    belongs_to :homepage
    belongs_to :product
    acts_as_list

    validates :homepage, :product, presence: true
    validates :product, uniqueness: { scope: :homepage_id }

    validates_uniqueness_of :homepage_id, scope: :product_id, message: :already_linked
  end
end
