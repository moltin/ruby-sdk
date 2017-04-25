module Moltin
  module Models
    class Variation < Models::Base
      attributes :type, :id, :name, :options, :meta, :relationships

      def variation_options
        client.variation_options(variation_id: id)
      end
    end
  end
end
