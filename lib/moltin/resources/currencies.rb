module Moltin
  module Resources
    class Currencies < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'currency'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Currency
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/currencies"
      end
    end
  end
end
