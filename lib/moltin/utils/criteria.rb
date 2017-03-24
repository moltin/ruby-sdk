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

      def sort(order)
        criteria['sort'] = order
        self
      end

      def filter(filters)
        criteria['filter'] ||= {}
        criteria['filter'].merge!(filters)
        self
      end

      def with(*includes)
        criteria['include'] ||= []
        includes.each { |i| criteria['include'] << i }
        self
      end

      def each(&block)
        collection.each(&block)
      end

      def [](value)
        collection[value]
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

      private

      def collection
        @collection ||= @klass.load_collection(@uri, formatted_criteria)
      end

      def formatted_criteria
        @formatted_criteria ||= lambda do
          criteria['filter'] = stringify_filter
          criteria['include'] = stringify_includes
          criteria.reject { |_k, v| v.nil? }
        end.call
      end

      def stringify_filter
        return nil unless criteria['filter']

        str = ''
        criteria['filter'].each_with_index do |(type, values), i1|
          values.each_with_index do |(field, value), i2|
            str << ':' if i1 > 0 || i2 > 0
            value = "(#{value.join(',')})" if value.respond_to?(:each)
            str += "#{type}(#{field},#{value})"
          end
        end

        str
      end

      def stringify_includes
        return nil unless criteria['include']

        criteria['include'].join(',')
      end
    end
  end
end
