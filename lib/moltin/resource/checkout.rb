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
                 :shipping,
                 :shipping_address

      attr_reader :data,
                  :cart,
                  :gateways,
                  :shipping_methods
      def initialize(params)
        @cart = params[:cart]
        super
      end

      def retrieve
        @cart = cart
        @data = Moltin::Api::Request.get("carts/#{cart.identifier}/checkout").result
        @gateways = Moltin::ResourceCollection.new('Moltin::Resource::Gateway', @data['gateways'].map { |_, v| v })
        @shipping_methods = Moltin::ResourceCollection.new('Moltin::Resource::ShippingMethod', @data['shipping']['methods'])
        self
      end

      def save(customer, gateway, shipping, billing_address, shipping_address = 'bill_to')
        data = {
          customer: customer,
          gateway:  gateway,
          shipping: shipping,
          bill_to:  billing_address,
          ship_to:  shipping_address
        }
        response = Moltin::Api::Request.post("carts/#{cart.identifier}/checkout", data)
        @order_id = response.result['id'] if response.success?
        data_order = JSON.parse(response.response)
        Moltin::Resource::Order.new(data_order['result'])
      end

      def self.process!(order_id, method, options)
        Moltin::Api::Request.post("checkout/payment/#{method}/#{order_id}", options)
      end
    end
  end
end
