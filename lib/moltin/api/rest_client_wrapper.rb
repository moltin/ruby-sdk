require 'moltin/api/request'
require 'moltin/api/rest_client_wrapper'
module Moltin
  module Api
    class RestClientWrapper
      def initialize(path, custom_headers = {})
        custom_headers['X-Language'] = locale if locale
        headers   = Moltin::Api::Request.headers(custom_headers)
        params    = { verify_ssl: OpenSSL::SSL::VERIFY_NONE, headers: headers }
        endpoint  = Moltin::Api::Request.build_endpoint(path)
        @instance = RestClient::Resource.new(endpoint, params)
      end

      def get
        @instance.get do |response|
          yield response
        end
      end

      def post(data = {})
        @instance.post data do |response|
          yield response
        end
      end

      def put(data = {})
        @instance.put data do |response|
          yield response
        end
      end

      def delete
        @instance.delete do |response|
          yield response
        end
      end

      private

      def locale
        local = I18n.locale.to_s.upcase
        return local if ['NL', 'FR'].include?(local) # TODO redo
      rescue
        nil
      end
    end
  end
end
