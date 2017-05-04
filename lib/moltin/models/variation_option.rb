module Moltin
  module Models
    class VariationOption < Models::Base
      attributes :type, :id, :name, :variation_id

      def modifiers
        original_payload['modifiers'].map do |opt|
          opt[:variation_id] = variation_id
          opt[:option_id] = id
          ProductModifier.new(opt, @client)
        end
      end

      def product_modifiers
        client.product_modifiers(variation_id: variation_id, option_id: id)
      end
    end
  end
end
