require 'moltin/api/request'
require 'moltin/support/inflector'

module Moltin
  module Api
    class CrudResource

      def self.all
        response = Request.get("#{resource_namespace}/search")
      end

      def self.find(id)
        response = Request.get("#{resource_namespace}/#{id}")
      end

      def self.where(query)
      end

      def self.create(data)
      end

      def save
      end

      def update_attributes
      end

      def delete
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
