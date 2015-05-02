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
        response.body
      end

      def success?
        code.match(/(2|3)[0-9]{2}/)
      end
    end
  end
end
