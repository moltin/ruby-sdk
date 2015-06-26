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

      def to_pay
        price = (@data['totals']['raw']['shipping_price'] + @data['totals']['raw']['total']).round(2)
        @data['currency']['data']['format'].gsub('{price}', sprintf('%5.2f', price))
      end
    end
  end
end
