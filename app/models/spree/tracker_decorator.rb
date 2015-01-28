Spree::Tracker.class_eval do
  belongs_to :store, inverse_of: :trackers

  validates_presence_of :store_id, if: -> { Spree::Tracker.where(store_id: nil).exists? },
    message: "only one master store is allowed at a time."

  def self.current(domain)
     where(active: true, environment: Rails.env)
    .joins(:store)
    .where("spree_stores.domains LIKE ?", "%#{domain}%")
    .first
  end

  def self.master
    find_by(active: true, store_id: nil)
  end

  def master?
    store_id.nil?
  end

  def analytics_name
    master? ? 'master' : store.code.underscore
  end
end
