module Moltin
  module Resources
    class VariationOptions < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'product-variation-option'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Variation
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/variations/#{options[:variation_id]}/variation-options"
      end
    end
  end
end
