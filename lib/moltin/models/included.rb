module Moltin
  module Models
    class Included < Models::Base
      def find(type, id)
        attributes = @original_payload[type.to_s].detect do |e|
          e['id'] == id
        end

        return nil unless attributes
        klass = Moltin::Configuration::MOLTIN_OPTIONS[:resources][attributes['type'].to_sym][:model]
        klass.new(attributes, client)
      end
    end
  end
end
