require 'moltin/api/request'
require 'moltin/support/inflector'
require 'moltin/resource_collection'

module Moltin
  module Api
    class CrudResource

      @@attributes = []

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

      def self.attributes(*attrs)
        attrs.each do |attr|
          @@attributes.push(attr)
        end
      end

      def self.create(data)
      end

      attr_reader :data

      def initialize(data = {})
        puts "#{self.class.name}.new { #{data} }"
        @data ||= {}
        puts "- @@attributes #{@@attributes}"
        @@attributes.each do |attr|
          # @data[attr] ||= nil
        end
        data.each do |key, value|
          @data[key.to_sym] = value
        end
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
        puts "method_missing #{method}"
        if method.to_s.index('=')
          key = method.to_s.split('=').first.gsub('_attributes', '').to_sym
          return set_attribute(key, args[0]) if @@attributes.include? key
        elsif @@attributes.include? method
          return get_attribute(method)
        end
        super
      end

      def respond_to?(method)
        puts "respond_to? #{method}"
        if method.to_s.index('_attributes=')
          puts "#{@@attributes}.include? #{method.to_s.split('_attributes').first.to_sym}"
          puts @@attributes.include?(method.to_s.split('_attributes').first.to_sym) ? "  true" : "  false"
          return @@attributes.include?(method.to_s.split('_attributes').first.to_sym)
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

      def to_hash
        to_s
      end

      private

      def self.resource_name
        name.to_s.downcase.gsub("moltin::resource::", "")
      end

      def self.resource_namespace
        Moltin::Support::Inflector.pluralize(resource_name)
      end

      def set_attribute(key, value)
        @data[key] = value
      end

      def get_attribute(key)
        puts "{ data = #{@data} }"
        return nil unless @data[key]
        if @data[key].is_a? Hash
          return @data[key]['value']
        end
        puts "  #{@data[key]}"
        @data[key]
      end
    end
  end
end
