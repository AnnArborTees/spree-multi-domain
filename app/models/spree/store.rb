module Spree
  class Store < ActiveRecord::Base

    has_and_belongs_to_many :products, :join_table => 'spree_products_stores'
    has_and_belongs_to_many :homepage_slides,  -> { where(active: 1) }, :join_table => 'spree_stores_homepage_slides'
    has_and_belongs_to_many :taxonomies, :join_table => 'spree_taxonomies_stores'
    has_many :orders

    has_one :homepage

    has_many :store_payment_methods
    has_many :payment_methods, :through => :store_payment_methods

    has_many :store_shipping_methods
    has_many :shipping_methods, :through => :store_shipping_methods

    has_and_belongs_to_many :promotion_rules, :class_name => 'Spree::Promotion::Rules::Store', :join_table => 'spree_promotion_rules_stores', :association_foreign_key => 'promotion_rule_id'

    belongs_to :parent, class_name: 'Spree::Store', inverse_of: :children, foreign_key: 'parent_id'
    has_many :children, class_name: 'Spree::Store', inverse_of: :parent, foreign_key: 'parent_id'

    validates :name, :code, :slug, :domains, :email, presence: true
    validates :slug, uniqueness: true, unless: proc { slug.nil? || slug.empty? }

    before_save :ensure_default_exists_and_is_unique
    before_validation proc { self.slug = code if slug.nil? }
    before_validation proc { self.parent_id = nil if parent_id == id }

    scope :default, lambda { where(:default => true) }
    scope :by_domain, lambda { |domain| where("domains like ?", "%#{domain}%") }

    has_attached_file :logo,
      :styles => { :mini => '48x48>', :small => '100x100>', :medium => '250x250>' },
      :default_style => :medium,
      :url => 's/:id/:style/:basename.:extension',
      :path => 's/:id/:style/:basename.:extension',
      :convert_options => { :all => '-strip -auto-orient' }

    def path(*args)
      "/s/#{slug}"
    end

    # TODO remove this
    def self.with_code(code)
      all.reject { |s| s.code != code }.first
    end

    def self.current(domain = nil)
      current_store = domain ? Store.by_domain(domain).first : nil
      current_store || first_found_default
    end

    def self.first_found_default
      @cached_default ||= Store.default.first
    end

    def matches_domain?(domain)
      domains.split(/[,\s]/)
             .reject(&:empty?)
             .map(&:strip)
             .any? { |d| domain.include?(d) || d.include?(domain) }
    end

    def title
      return seo_title unless seo_title.nil? || seo_title.empty?
      name
    end

    def all_children
      all = []
      children = self.children.to_a
      children.each do |child|
        all << child
        all += child.all_children
      end
      all
    end

    def up_to_top
      parents = [self, parent]
      until parents.last.nil?
        parents << parents.last.parent 
      end
      parents[0...-1]
    end

    def up_to(top)
      return up_to_top if top == :top
      return [self] if self == top
      return [] if parent.nil?

      parents = [self, parent]
      until parents.last.nil? || parents.last == top
        parents << parents.last.parent
      end

      if parents.last.nil?
        []
      else
        parents.compact
      end
    end

    def ensure_default_exists_and_is_unique
      if default and not Store.default.empty?
        Store.update_all(default: false)
      elsif Store.default.empty?
        self.default = true
      end
    end

    def assign_slug_to_code_if_slug_is_nil
      self.slug = code if slug.nil?
    end

    def self.homepage_layouts
      %w(default)
    end
  end
end
