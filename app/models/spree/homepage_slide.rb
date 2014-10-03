module Spree
  class HomepageSlide < ActiveRecord::Base
    validates :name, :description, :label, :text, presence: true
    validates :name, uniqueness: true
    has_attached_file :image, styles: { homepage: '900x250!', thumb: '300x85!'},
                      default_style: :homepage,
                      url: '/spree/homepage_slides/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/homepage_slides/:id/:style/:basename.:extension'

    has_and_belongs_to_many :stores, join_table: 'spree_stores_homepage_slides'

  end
end
