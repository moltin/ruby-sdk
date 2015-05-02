require 'moltin/config'
require 'moltin/api/response'
require 'rest-client'

module Moltin
  module Api
    class Client

      def self.get(path, custom_headers = {})
        client = RestClient::Resource.new(
          build_endpoint(path),
          {
            verify_ssl: OpenSSL::SSL::VERIFY_NONE,
            headers: headers(custom_headers),
          }
        )
        client.get do |response, request, result|
          Moltin::Api::Response.new response
        end
      end

      private

      def self.build_endpoint(path)
        "https://#{Moltin::Config.api_host}/#{Moltin::Config.api_version}/#{path}"
      end

      def self.default_headers
        {
          'Bearer' => 'XXXXX',
        }
      end

      def self.headers(custom_headers = {})
        default_headers.merge(custom_headers)
      end

    end
  end
end
