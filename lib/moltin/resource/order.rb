require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class Order < Moltin::Api::CrudResource

      attributes :id,
        :customer,
        :gateway,
        :status,
        :ship_to,
        :bill_to,
        :shipping

      def items
        response = Moltin::Api::Request.get("orders/#{id}/items")
        return unless response.success?
        content = response.result
        Moltin::ResourceCollection.new('Moltin::Resource::Product', content)
      end

      def ship_to
        Moltin::Resource::Address.new @data['ship_to']['data']
      end

      def bill_to
        Moltin::Resource::Address.new @data['ship_to']['data']
      end

      def shipping
        Moltin::Resource::ShippingMethod.new @data['shipping']['data']
      end

      def gateway
        Moltin::Resource::Gateway.new @data['gateway']['data']
      end

      def add_shipping_price(shipping_price)
        Moltin::Resource::Order.update(id, { shipping_price: shipping_price, total: to_pay + shipping_price })
        Moltin::Resource::Order.find(id)
      end

      def add_shipping_address(shipping_address_id)
        Moltin::Resource::Order.update(id, { ship_to: shipping_address_id })
        Moltin::Resource::Order.find(id)
      end

      def to_pay
        @data['totals']['rounded']['total']
      end

      def process(token)
        Moltin::Resource::Checkout.process!(id, "purchase", { source: token })
      end
    end
  end
end
