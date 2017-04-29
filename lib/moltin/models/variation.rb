module Moltin
  module Models
    class Variation < Models::Base
      attributes :type, :id, :name, :meta, :relationships

      def options
        original_payload['options'].map do |opt|
          VariationOption.new(opt, @client)
        end
      end

      def variation_options
        client.variation_options(variation_id: id)
      end
    end
  end
end
