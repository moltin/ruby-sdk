module Moltin
  module Resources
    class OrderItems < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'order_item'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::OrderItem
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/orders/#{options[:order_id]}/items"
      end
    end
  end
end
