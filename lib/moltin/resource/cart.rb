require 'moltin/resource_collection'
require 'moltin/api/request'
require 'moltin/resource/product'

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
      end

      def retrieve
        response = Moltin::Api::Request.get("cart/#{identifier}")
        return unless response.success?
        @items = Moltin::ResourceCollection.new 'Moltin::Resource::Product', response.result['contents'].map { |k, v| v }
        @item_count = response.result['total_items']
        @item_subtotal = response.result['totals']['formatted']['without_tax']
        @item_tax = response.result['totals']['formatted']['tax']
        @item_total = response.result['totals']['formatted']['with_tax']
      end

      def add_item(options)
        Moltin::Api::Request.post("cart/#{identifier}", options)
      end

      def items
        @items || []
      end
    end
  end
end
