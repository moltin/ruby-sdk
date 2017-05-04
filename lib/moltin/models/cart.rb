module Moltin
  module Models
    class Cart < Models::Base
      attributes :type, :id, :meta, :links, :timestamps

      def items
        client.items(cart_id: id).all
      end

      def add(data)
        data[:type] ||= data[:id] ? 'cart_item' : 'custom_item'
        data[:quantity] ||= 1
        client.items(cart_id: id).create(data)
      end

      def update(item_id, data)
        client.items(cart_id: id).update(item_id, data)
      end

      def remove(cart_item_id)
        client.items(cart_id: id).delete(cart_item_id)
      end

      def checkout(customer:, billing_address:, shipping_address:)
        client.carts.checkout(id, customer: customer,
                                  billing_address: billing_address,
                                  shipping_address: shipping_address)
      end
    end
  end
end
