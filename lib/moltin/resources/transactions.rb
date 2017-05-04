module Moltin
  module Resources
    class Transactions < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'transaction'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Transaction
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/orders/#{options[:order_id]}/transactions"
      end
    end
  end
end
