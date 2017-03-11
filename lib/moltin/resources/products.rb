module Moltin
  module Resources
    class Products < Resources::Base
      private

      def uri
        "#{@config.version}/products"
      end
    end
  end
end
