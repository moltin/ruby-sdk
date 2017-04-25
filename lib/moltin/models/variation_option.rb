module Moltin
  module Models
    class VariationOption < Models::Base
      attributes :type, :id, :name, :variation_id

      def product_modifiers
        client.product_modifiers(variation_id: variation_id, option_id: id)
      end
    end
  end
end
