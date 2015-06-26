require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class ShippingMethod < Moltin::Api::CrudResource

      attributes :id,
        :identifier,
        :slug,
        :title,
        :company,
        :status,
        :price,
        :price_min,
        :price_max,
        :weight_min,
        :weight_max,
        :tax_bank

    end
  end
end
