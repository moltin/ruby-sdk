module Moltin
  module Utils
    class Response
      def initialize(body)
        @body = body
      end

      def data
        @body['data']
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
