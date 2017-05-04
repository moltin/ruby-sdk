module Moltin
  module Models
    class Order < Models::Base
      attributes :type, :id, :status, :payment, :shipping, :customer,
                 :shipping_address, :billing_address, :relationships, :meta

      def items
        client.order_items(order_id: id).all
      end

      def transactions
        client.transactions(order_id: id).all
      end

      def pay(data)
        client.payments(order_id: id).create(data)
      end
    end
  end
end
