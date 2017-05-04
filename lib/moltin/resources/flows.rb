module Moltin
  module Resources
    class Flows < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'flow'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Flow
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/flows"
      end
    end
  end
end
