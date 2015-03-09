module Spree
  class Homepage < ActiveRecord::Base
    validates :name, presence: true
    validates :store_id, uniqueness: true, unless: 'name.blank?'

    has_many :homepage_products, -> { order(:position) }, dependent: :delete_all, inverse_of: :homepage, foreign_key: 'homepage_id'
    has_many :products, through: :homepage_products, foreign_key: 'product_id'
    belongs_to :store

  end
end
