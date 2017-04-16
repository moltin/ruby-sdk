module Moltin
  module Resources
    class Brands < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'brand'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Brand
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/brands"
      end
    end
  end
end
