require 'moltin/resource_collection'
require 'moltin/api/request'
require 'moltin/resource/product'
require 'moltin/resource/checkout'

module Moltin
  module Resource
    class Cart
      attr_reader :identifier
      attr_reader :item_count
      attr_reader :item_tax
      attr_reader :item_total
      attr_reader :item_subtotal

      def initialize(identifier = nil)
        @identifier = identifier || SecureRandom.hex(12)
        @item_count = 0
        @item_tax = 0
        @item_total = 0
        @item_subtotal = 0
      end

      def retrieve
        response = Moltin::Api::Request.get("carts/#{identifier}")
        return unless response.success?
        content        = response.result['contents'].map { |k, v| v.merge('identifier' => k) }
        @items         = Moltin::ResourceCollection.new('Moltin::Resource::Product', content)
        @item_count    = response.result['total_items']
        @item_subtotal = response.result['totals']['pre_discount']['formatted']['without_tax']
        @item_tax      = response.result['totals']['pre_discount']['formatted']['tax']
        @item_total    = response.result['totals']['pre_discount']['formatted']['with_tax']
        self
      end

      def checkout
        Moltin::Resource::Checkout.new(cart: self).retrieve
      end

      def add_item(options)
        Moltin::Api::Request.post("carts/#{identifier}", options)
      end

      def remove_item(product_identifier)
        Moltin::Api::Request.delete("carts/#{identifier}/item/#{product_identifier}")
      end

      def items
        @items || []
      end

      def weigth
        items.inject(0) { |sum, i| sum + i.data['weight'] * i.data['quantity'] }
      end

      def destroy
        Moltin::Api::Request.delete("carts/#{identifier}")
      end
    end
  end
end
