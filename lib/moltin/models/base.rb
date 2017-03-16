module Moltin
  module Models
    class Base
      class << self
        attr_reader :_attributes

        def attributes(*attrs)
          attrs.push(:original_payload)
          attr_accessor(*attrs)
          @_attributes = attrs.map(&:to_sym)
        end
      end

      def initialize(attributes = {})
        self.class._attributes.each do |name|
          instance_variable_set("@#{name}", attributes[name.to_sym] ||
                                            attributes[name.to_s])
        end
        self.original_payload = attributes
      end
    end
  end
end
