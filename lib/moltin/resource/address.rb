require 'moltin/api/crud_resource'

module Moltin
  module Resource
    class Address < Moltin::Api::CrudResource

      attributes :id,
        :save_as,
        :email,
        :phone,
        :first_name,
        :last_name,
        :address_1,
        :address_2,
        :city,
        :county,
        :postcode,
        :country,
        :customer

    end
  end
end
