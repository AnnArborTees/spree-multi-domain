module SpreeMultiDomain
	class MixedStore
		def initialize(*args)
			@stores = args.map do |e|
				if e.is_a? String
					if e.index('/')
            # TODO try Spree::Store.where code: e.split('/')
						e.split('/').map { |s| Spree::Store.all.where code: s }
					else
						Spree::Store.where code: e
					end
				elsif e.is_a? Fixnum
					Spree::Store.where id: e
				elsif e.is_a? Spree::Store
					e
        elsif e.respond_to? :to_a
          e.to_a
				end
      end.flatten
		end

		def name
			@stores.map { |s| s.name }.join '/'
		end

		def ids
			@stores.map { |s| s.id }
		end

		def matches_domain?(domain)
			if @stores.first
				return true if @stores.first.domains.include? domain
			end
			return false
		end

		def respond_to?(func)
			if responder_of(func) then true else super end
		end

		def method_missing(func, *args, &block)
			responder = responder_of func
			if responder then responder.send(func, *args, &block) else super end
		end

	private
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