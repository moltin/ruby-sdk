module Moltin
  module Api
    class Response
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def code
        response.code
      end

      def body
        response.to_s
      end

      def as_hash
        JSON.parse(response.to_s)
      end

      def result
        return unless success?
        as_hash['result']
      end

      def success?
        [200, 201, 302].include?(code)
      end

    end
  end
end
