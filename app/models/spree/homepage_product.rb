require 'acts_as_list'

module Spree
  class HomepageProduct < ActiveRecord::Base
    acts_as_list

    belongs_to :homepage, inverse_of: :homepage_products
    belongs_to :product

    validates :homepage, :product, presence: true
    validates :product, uniqueness: { scope: :homepage_id }

    validates_uniqueness_of :homepage_id, scope: :product_id, message: :already_linked

    validate :position_is_not_nil

    private

    def position_is_not_nil
      if position.nil? || position == 0
        homepage_products = HomepageProduct.where(homepage_id: homepage_id)

        positions = (1..homepage_products.size).to_a
        taken_positions = homepage_products
          .where.not(position: nil)
          .pluck(:position)

        available_positions = positions - taken_positions

        return if available_positions.empty?

        self.set_list_position(available_positions.first)
      end
    end
  end
end
