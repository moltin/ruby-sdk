require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class Gateway < Moltin::Api::CrudResource

      attributes :id,
        :description,
        :enabled,
        :name,
        :settings,
        :slug,
        :store_id

    end
  end
end
