require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class Customer < Moltin::Api::CrudResource

      attributes :id,
        :first_name,
        :last_name,
        :email,
        :history

    end
  end
end
