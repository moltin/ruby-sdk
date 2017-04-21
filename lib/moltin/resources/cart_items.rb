module Moltin
  module Resources
    class CartItems < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'cart_item'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::CartItem
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/carts/#{options[:cart_id]}/items"
      end
    end
  end
end
