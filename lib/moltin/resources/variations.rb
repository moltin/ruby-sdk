module Moltin
  module Resources
    class Variations < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'product-variation'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Variation
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/variations"
      end
    end
  end
end
