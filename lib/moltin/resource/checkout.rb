require 'moltin/api/crud_resource'
require 'moltin/api/request'
require 'moltin/resource/cart'
require 'moltin/resource/gateway'

module Moltin
  module Resource
    class Checkout < Moltin::Api::CrudResource

      attributes :id,
        :billing_address,
        :cart,
        :gateway,
        :shipping_address

      attr_reader :gateways

      def retrieve
        response = Moltin::Api::Request.get("carts/#{cart.identifier}/checkout")
        @gateways = Moltin::ResourceCollection.new 'Moltin::Resource::Gateway', response.result['gateways'].map { |k, v| v }
        self
      end

      def save
        data = {
          gateway: @data[:gateway],
          bill_to: (@data[:billing_address].data if @data[:billing_address]),
          ship_to: (@data[:shipping_address].data if @data[:shipping_address]) || "bill_to",
        }
        puts " "
        puts " "
        puts data.to_json
        Moltin::Api::Request.post("carts/#{cart.identifier}/checkout", data)
      end

    end
  end
end
