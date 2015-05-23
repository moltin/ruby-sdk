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
        as_hash['result']
      end

      def success?
        code.to_s.match(/(2|3)[0-9]{2}/)
      end
    end
  end
end
