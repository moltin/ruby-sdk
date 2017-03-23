module Moltin
  module Resources
    class Products < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'product'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Product
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/products"
      end
    end
  end
end
