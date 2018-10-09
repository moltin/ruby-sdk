module Moltin
  module Support
    class AuthenticationError < StandardError
      def initialize(msg = 'Moltin Client is not authenticated')
        super
      end
    end
  end
end
