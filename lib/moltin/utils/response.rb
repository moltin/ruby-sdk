module Moltin
  module Utils
    class Response
      def initialize(model, body)
        @model = model
        @body = body
      end

      def errors
        @body['errors']
      end

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
        @body['links']
      end

      def included
        @body['included']
      end

      def meta
        @body['meta']
      end
    end
  end
end
