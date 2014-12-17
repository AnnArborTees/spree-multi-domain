module Spree
  class HomepageProduct < ActiveRecord::Base
    belongs_to :homepage
    belongs_to :product

    validates :homepage, :product, presence: true
    validates :product, uniqueness: { scope: :homepage_id }

  end
end