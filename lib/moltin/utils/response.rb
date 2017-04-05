module Moltin
  module Utils
    class Response
      attr_accessor :body

      def initialize(model, resp)
        @model = model
        @status = resp[:status]
        @body = resp[:body]
      end

      def errors
        @body['errors']
      end

      # Public: Extract the data part of the response body
      # and instantiate each resource with the given model class
      #
      # Returns an array of Models object or one Model object
      # Returns nil if the body contains errors
      def data
        return nil if errors

        if @body['data'].is_a?(Array)
          @body['data'].map do |attributes|
            @model.new(attributes)
          end
        else
          @model.new(@body['data'])
        end
      end

      def links
        @body['links'] || {}
      end

      def included
        @body['included'] || {}
      end

      def meta
        @body['meta'] || {}
      end
    end
  end
end
