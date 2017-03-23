module Moltin
  module Models
    class Attribute < Models::Base
      attributes :label, :value, :type, :validation, :required, :options,
                 :description, :items, :validation
    end
  end
end
