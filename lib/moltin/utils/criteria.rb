module Moltin
  module Utils
    class Criteria
      extend Forwardable
      def_delegators :response, :first, :last, :errors, :data, :links, :included,
                     :meta, :length

      def initialize(klass, uri)
        @klass = klass
        @uri = uri
      end

      # Public: Give an idiomatic way to load the records
      #
      # Returns the current instance of Criteria
      def all
        self
      end

      # Public: Set the limit parameter
      #
      # args - the number of records wanted (Example: 10)
      #
      # Returns the current instance of Criteria
      def limit(args)
        criteria['page[limit]'] = args
        self
      end

      # Public: Set the page[offset] parameter
      #
      # args - the offset of records wanted (Example: 10)
      #
      # Returns the current instance of Criteria
      def offset(args)
        criteria['page[offset]'] = args
        self
      end

      # Public: Set the sort parameter
      #
      # args - the sort parameter (Example: 'name' or '-name')
      #
      # Returns the current instance of Criteria
      def sort(args)
        criteria['sort'] = args
        self
      end

      # Public: Merge the given hash with the filter hash
      #
      # args - a hash of filtering options
      #
      # Returns the current instance of Criteria
      def filter(args)
        criteria['filter'] ||= {}
        criteria['filter'].merge!(args)
        self
      end

      # Public: Add a list of included resources to the criteria hash
      #
      # includes - a list of resources (Example: with(:categories, :brands))
      #
      # Returns the current instance of Criteria
      def with(*includes)
        criteria['include'] ||= []
        includes.each { |i| criteria['include'] << i }
        self
      end

      # Public: Create the basic set of query parameters
      #
      # Returns a hash of parameters
      def criteria
        @criteria ||= {
          'sort' => nil,
          'filter' => nil,
          'page[limit]' => nil,
          'page[offset]' => nil,
          'include' => nil
        }
      end

      # Public: Load the results from the server
      #
      # Returns a Moltin::Utils::Response instance
      def response
        @response ||= @klass.load_collection(@uri, formatted_criteria)
      end

      private

      # Private: Turn the criteria into query parameters
      #
      # Returns a formatted hash of query parameters
      def formatted_criteria
        @formatted_criteria ||= lambda do
          criteria['filter'] = stringify_filter
          criteria['include'] = stringify_includes
          criteria.reject { |_k, v| v.nil? }
        end.call
      end

      # Private: Convert the filter hash to a string
      #
      # Returns a string of filters
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

      # Private: Convert the include array to a string
      #
      # Returns a string of included resources
      def stringify_includes
        return nil unless criteria['include']

        criteria['include'].join(',')
      end
    end
  end
end
