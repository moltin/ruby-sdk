module Moltin
  module Resources
    class Payments < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'payment'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Payment
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/orders/#{options[:order_id]}/payments"
      end
    end
  end
end
