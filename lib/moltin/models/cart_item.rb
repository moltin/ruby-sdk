module Moltin
  module Models
    class CartItem < Models::Base
      attributes :type, :id, :quantity, :name, :sku, :description, :price
    end
  end
end
