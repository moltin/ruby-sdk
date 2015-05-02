require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class Product < Moltin::Api::CrudResource
      def image_url
        return nil unless images.any?
        images[0]['url']['https']
      end
    end
  end
end
