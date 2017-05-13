module Moltin
  module Models
    class Base
      class << self
        attr_accessor :attributes_list, :has_many_list, :belongs_list

        # Public: defines the list of attributes for the current class
        # Inherit from this class and use
        # MyClass < Moltin::Models::Base
        #   attributes :id, :name
        #
        # attrs - a list of attributes (:id, :name)
        #
        # Also pushes the original payload key in the list of attributes
        def attributes(*attrs)
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

      attr_accessor :client, :original_payload, :relationships, :flow_fields
      # Public: initialize the model and set the values for each attribute
      # based on the content of the passed attributes hash
      #
      # attributes - a hash containing keys present in the class 'attributes'
      # and the values to associate with it.
      #
      def initialize(attributes = {}, client = nil)
        self.class.attributes_list ||= []

        self.class.attributes_list.each do |name|
          instance_variable_set("@#{name}", attributes[name.to_sym] ||
                                            attributes[name.to_s])
        end

        self.relationships = attributes['relationships']
        ((self.class.has_many_list || []) + (self.class.belongs_list || [])).each do |name|
          next unless relationships && relationships[name.to_s]
          instance_variable_set("@#{name}", relationships[name.to_s]['data'].map do |rel|
            Moltin::Configuration::MOLTIN_OPTIONS[:resources][rel['type'].to_sym][:model].new(rel, client)
          end)
        end

        self.original_payload = attributes
        @client = client

        self.flow_fields = OpenStruct.new(attributes.dup.delete_if do |k, _v|
          self.class.attributes_list.include?(k.to_sym)
        end)
      end

      def to_model
        self
      end

      def inspect
        s = "#<#{self.class.name}:#{object_id} "
        self.class.attributes_list.each { |attr| s << "@#{attr}=#{send(attr)}, " }
        ((self.class.has_many_list || []) + (self.class.belongs_list || [])).each do |attr|
          s << "@#{attr}=#{send(attr)}, "
        end

        s << "@original_payload=#{@original_payload}, "
        s << "@flow_fields=#{@flow_fields}, "
        s
      end
    end
  end
end
