module Moltin
  module Models
    class Base
      class << self
        attr_reader :attributes_list, :has_many_list, :belongs_list

        # Public: defines the list of attributes for the current class
        # Inherit from this class and use
        # MyClass < Moltin::Models::Base
        #   attributes :id, :name
        #
        # attrs - a list of attributes (:id, :name)
        #
        # Also pushes the original payload key in the list of attributes
        def attributes(*attrs)
          attrs.push(:original_payload)
          attrs.push(:relationships)
          attr_accessor(*attrs)
          @attributes_list = attrs.map(&:to_sym)
        end

        def has_many(*attrs)
          attr_accessor(*attrs)
          @has_many_list ||= []
          @has_many_list = (@has_many_list + attrs.map(&:to_sym)).uniq
        end

        def belongs_to(*attrs)
          attr_accessor(*attrs)
          @belongs_list ||= []
          @belongs_list += (@belongs_list + attrs.map(&:to_sym)).uniq
        end
      end

      # Public: initialize the model and set the values for each attribute
      # based on the content of the passed attributes hash
      #
      # attributes - a hash containing keys present in the class 'attributes'
      # and the values to associate with it.
      #
      def initialize(attributes = {})
        self.class.attributes_list.each do |name|
          instance_variable_set("@#{name}", attributes[name.to_sym] ||
                                            attributes[name.to_s])
        end
        self.relationships = attributes['relationships']
        self.original_payload = attributes
      end
    end
  end
end
