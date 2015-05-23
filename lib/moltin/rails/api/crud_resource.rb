require 'moltin/api/crud_resource'

module Moltin
  module Api
    class CrudResource

      def model_name
        "address"
      end

      def to_key
        nil
      end

      def to_model
        self
      end

      def persisted?
        false
      end

      def route_key
        "address"
      end

    end
  end
end
