module Moltin
  module Resources
    class ProductModifiers < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'product-modifier'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::ProductModifier
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/variations/#{options[:variation_id]}/variation-options" \
        "/#{options[:option_id]}/product-modifiers"
      end
    end
  end
end
