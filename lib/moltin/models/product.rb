module Moltin
  module Models
    class Product < Models::Base
      attributes :type, :id, :name, :slug, :sku, :manage_stock, :description,
                 :price, :status, :commodity_type, :dimensions, :weight, :links,
                 :relationships, :meta
      relationships :brands, :categories, :collections, :files
    end
  end
end
