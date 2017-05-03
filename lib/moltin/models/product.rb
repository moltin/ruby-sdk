module Moltin
  module Models
    class Product < Models::Base
      attributes :type, :id, :name, :slug, :sku, :manage_stock, :stock, :description,
                 :price, :status, :commodity_type, :dimensions, :weight, :links,
                 :relationships, :meta

      has_many :brands
      has_many :categories
      has_many :collections
      has_many :files
      has_many :variations

      def build
        client.products.build(id)
      end
    end
  end
end
