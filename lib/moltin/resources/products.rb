module Moltin
  module Resources
    class Products < Resources::Base
      private

      def type
        'product'
      end

      def model_name
        Moltin::Models::Product
      end

      def uri
        "#{@config.version}/products"
      end
    end
  end
end
