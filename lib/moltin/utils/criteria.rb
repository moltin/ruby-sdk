module Moltin
  module Utils
    class Criteria
      extend Forwardable
      def_delegators :collection, :errors, :data, :links, :included, :meta

      def initialize(klass, uri)
        @klass = klass
        @uri = uri
      end

      def all
        self
      end

      def limit(limit)
        criteria['page[limit]'] = limit
        self
      end

      def offset(offset)
        criteria['page[offset]'] = offset
        self
      end

      def order(order)
        criteria['sort'] = order
        self
      end

      def where(where)
        criteria['filter'] ||= {}
        criteria['filter'].merge(where)
        self
      end

      def includes(includes)
        criteria['include'] ||= []
        criteria['include'] = includes
        self
      end

      def each(&block)
        collection.each(&block)
      end

      def [](value)
        collection[value]
      end

      private

      def collection
        p criteria
        @collection ||= @klass.load_collection(@uri, criteria.reject { |k, v| v.nil? })
      end

      def criteria
        @criteria ||= {
          'sort' => nil,
          'filter' => nil,
          'page[limit]' => nil,
          'page[offset]' => nil,
          'include' => nil
        }
      end
    end
  end
end
