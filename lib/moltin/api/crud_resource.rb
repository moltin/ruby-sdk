require 'moltin/api/request'
require 'moltin/support/inflector'
require 'moltin/resource_collection'

module Moltin
  module Api
    class CrudResource

      def self.all
        search({})
      end

      def self.find(id)
      end

      def self.search(options)
        query_string = options.map { |k, v| "#{k}=#{v}" }.join('&')
        results = Request.get("#{resource_namespace}/search#{query_string ? "?#{query_string}" : ''}").result
        Moltin::ResourceCollection.new name, results
      end

      def self.create(data)
      end

      attr_reader :data

      def initialize(data)
        @data = data
      end

      def attributes
        @data.keys
      end

      def save
      end

      def assign_attributes
      end

      def delete
      end

      def method_missing(method, *args, &block)
        if @data.has_key? method.to_s
          if @data[method.to_s].is_a? Hash
            return @data[method.to_s]['value']
          end
          return @data[method.to_s]
        end
        super
      end

      def to_s
        _data = {}
        @data.keys.each do |attribute|
          _data[attribute] = send(attribute)
        end
        _data
      end

      private

      def self.resource_name
        name.to_s.downcase.gsub("moltin::resource::", "")
      end

      def self.resource_namespace
        Moltin::Support::Inflector.pluralize(resource_name)
      end

    end
  end
end
