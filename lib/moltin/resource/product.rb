require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class Product < Moltin::Api::CrudResource

      attributes :id,
        :identifier,
        :name,
        :title,
        :description,
        :quantity,
        :price,
        :images,
        :stock_level

      def image_url
        return nil unless images.any?
        images[0]['url']['https']
      end
    end
  end
end
