module Moltin
  module Models
    class CartItem < Models::Base
      attributes :type, :id, :product_id, :name, :sku, :quantity, :unit_price,
                 :value, :links, :meta
    end
  end
end
