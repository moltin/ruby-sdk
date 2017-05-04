module Moltin
  module Utils
    class Response
      attr_accessor :body, :response_status

      def initialize(model, resp, client = nil)
        @model = model
        @response_status = resp[:status]
        @body = resp[:body]
        @client = client
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
            @model.new(attributes, @client)
          end
        else
          @model.new(@body['data'] || @body, @client)
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

      def method_missing(method, *args, &block)
        super unless data.respond_to?(method)
        data.send(method, *args, &block)
      end

      def respond_to_missing?(method, include_private = false)
        data.respond_to?(method) || super
      end
    end
  end
end
