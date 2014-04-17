module SpreeMultiDomain
  module MultiDomainHelpers
    def self.included(receiver)
      receiver.send :helper, 'spree/products'
      receiver.send :helper, 'spree/taxons'

      receiver.send :before_filter, :add_current_store_ids_to_params
      receiver.send :helper_method, :current_store
      receiver.send :helper_method, :current_tracker
    end

    def current_store
      by_domain = current_store_for_domain
      if session[:store]
        if by_domain.empty?
          @current_store = MixedStore.new(current_domain, session[:store])
        else
          @current_store = MixedStore.new(current_domain, by_domain, session[:store])
        end
      else
        unless by_domain.empty? then @current_store = MixedStore.new(current_domain, by_domain)
                                else @current_store = MixedStore.new(current_domain, default_store)
        end
      end
    end

    def current_store_for_domain
      Spree::Store.by_domain(request.env['SERVER_NAME'])
    end

    def default_store
      Spree::Store.default
    end

    def current_domain
      request.env['SERVER_NAME']
    end

    def current_tracker
      @current_tracker ||= Spree::Tracker.current(request.env['SERVER_NAME'])
    end

    def get_taxonomies
      @taxonomies ||= current_store.present? ? Spree::Taxonomy.where(["store_id = ?", current_store.id]) : Spree::Taxonomy
      @taxonomies = @taxonomies.includes(:root => :children)
      @taxonomies
    end

    def add_current_store_ids_to_params
      params[:current_store_ids] = current_store.try(:ids) || current_store.try(:id)
    end
  end
end
