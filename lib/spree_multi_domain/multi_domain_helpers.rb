module SpreeMultiDomain
  module MultiDomainHelpers
    def self.included(receiver)
      receiver.send :helper, 'spree/products'
      receiver.send :helper, 'spree/taxons'

      receiver.send :before_filter, :add_current_store_id_to_params
      receiver.send :helper_method, :current_store
      receiver.send :helper_method, :session_store
      receiver.send :helper_method, :domain_store
      receiver.send :helper_method, :current_tracker
    end

    def current_store
      @current_store || session_store || domain_store || default_store
    end

    def current_store_for_domain
      @domain_store ||= Spree::Store.by_domain(request.env['SERVER_NAME']).first
    end
    alias_method :domain_store, :current_store_for_domain

    def session_store
      Spree::Store.find_by(id: session[:store])
    end

    def default_store
      Spree::Store.default.first
    end

    def current_domain
      request.env['SERVER_NAME']
    end

    def current_tracker
      @current_tracker ||= Spree::Tracker.current(request.env['SERVER_NAME'])
    end

    def get_taxonomies
      @taxonomies ||= current_store.present? ? current_store.taxonomies : Spree::Taxonomy
      @taxonomies = @taxonomies.includes(:root => :children)
      @taxonomies
    end

    def add_current_store_id_to_params
      id = current_store.try(:id)
      if id
        params[:current_store_id] = id
        session[:store] = id
      end
    end

  end
end
