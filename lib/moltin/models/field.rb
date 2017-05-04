module Moltin
  module Models
    class Field < Models::Base
      attributes :type, :id, :flow_id, :field_type, :slug, :name,
                 :required, :unique, :default, :enabled, :validation_rules,
                 :description, :links, :meta, :relationships
    end
  end
end
