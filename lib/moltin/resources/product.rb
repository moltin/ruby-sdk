module Moltin
  module Resources
    class Product < Resources::Base
      private

      def uri
        "#{@config.version}/products"
      end
    end
  end
end
