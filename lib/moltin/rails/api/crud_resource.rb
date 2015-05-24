require 'moltin/api/crud_resource'

module Moltin
  module Api
    class CrudResource

      def model_name
        self.class.name.split('::').last.downcase
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
        model_name
      end

    end
  end
end
