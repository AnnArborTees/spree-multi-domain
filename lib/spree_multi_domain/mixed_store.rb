module SpreeMultiDomain
  class MixedStore
    def initialize(domain, *args)
      @current_domain = domain
      @stores = args.map do |e|
        parse_arg e
      end.flatten
    end

    def has_duplicate?
      ids = []
      @stores.each do |store|
        return true if ids.include? store.id
        ids << store.id
      end
      false
    end

    def id_is_duplicate?(store_id)
      ids = []
      @stores.each do |store|
        return true if ids.include? store.id && store.id == store_id
        ids << store.id
      end
    end

    def without_duplicates(as_mixed_store = true)
      new_stores = @stores.reject { |s| id_is_duplicate? s.id }
      return MixedStore.new(@current_domain, new_stores) if as_mixed_store
      return new_stores
    end

    def path
      if @current_domain && matches_domain?
        @stores[1..-1].map { |s| s.slug }.join '/'
      else
        @stores.map { |s| s.slug }.join '/'
      end
    end

    def full_path(root = '/')
      if root[-1] != '/' then root << '/' end
      if path.empty?
        return root
      else
        return "#{root}stores/#{path}"
      end
    end

    def name
      @stores.map { |s| s.name }.join '/'
    end

    def ids
      @stores.map { |s| s.id }
    end

    def matches_domain?(domain = nil)
      if @stores.first
        return true if @stores.first.domains.include? domain || @current_domain
      end
      false
    end

    def ordered_properly?
      current_index = -1
      @stores.each do |store|
        if store.url_index
          if store.url_index > current_index
            current_index = store.url_index
          else
            return false
          end
        end
      end
      true
    end

    def [](*args)
      return MixedStore.new(@current_domain, @stores[*args])
    end

    def ==(other)
      @stores.each do |store|
        return true if store == other
      end
      false
    end

    def contains_any_of?(*args)
      parsed_args = args.map do |e|
        parse_arg e
      end.flatten.compact
      @stores.each do |store|
        parsed_args.each do |arg|
          return true if store == arg
        end
      end
      false
    end

    def respond_to?(func)
      if super || responder_of(func)
        true
      else
        false
      end
    end

    def method_missing(func, *args, &block)
      responder = responder_of func
      if responder then responder.send(func, *args, &block) else super end
    end

  private
    def parse_arg(arg)
      if arg.is_a? String
        if arg.index('/')
          arg.split('/').map { |s| Spree::Store.all.where slug: s }
        else
          Spree::Store.where slug: arg
        end
      elsif arg.is_a? Fixnum
        Spree::Store.where id: arg
      elsif arg.is_a? Spree::Store
        arg
      elsif arg.respond_to? :to_a
        arg.to_a.map do |a|
          parse_arg a
        end
      end
    end

    def responder_of(func)
      if @stores.first && @stores.first.respond_to?(func)
        return @stores.first
      elsif @stores.respond_to?(func)
        return @stores
      else
        return nil
      end
    end

  end
end
