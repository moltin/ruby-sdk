module Moltin
  module Resources
    class Orders < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'order'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Order
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/orders"
      end
    end
  end
end
