Spree::LineItem.class_eval do
  belongs_to :store, class_name: 'Spree::Store'
  has_many :trackers, through: :store
end
