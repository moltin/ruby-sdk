module Moltin
  module Models
    class OrderItem < Models::Base
      attributes :type, :id, :quantity, :name, :sku, :description, :price
    end
  end
end
