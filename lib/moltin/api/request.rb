require 'moltin/api/client'

module Moltin
  module Api
    class Request
      def self.get(path, custom_headers = {})
        request = RestClient::Resource.new(
          build_endpoint(path),
          {
            verify_ssl: OpenSSL::SSL::VERIFY_NONE,
            headers: headers(custom_headers),
          }
        )
        request.get do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.post(path, data, custom_headers = {})
        request = RestClient::Resource.new(
          build_endpoint(path),
          {
            verify_ssl: OpenSSL::SSL::VERIFY_NONE,
            headers: headers(custom_headers),
          }
        )
        request.post data do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.delete(path, custom_headers = {})
        request = RestClient::Resource.new(
          build_endpoint(path),
          {
            verify_ssl: OpenSSL::SSL::VERIFY_NONE,
            headers: headers(custom_headers),
          }
        )
        request.delete do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.build_endpoint(path)
        "https://#{Moltin::Config.api_host}/#{Moltin::Config.api_version}/#{path}"
      end

      def self.default_headers
        {
          'Authorization' => "Bearer #{Moltin::Api::Client.access_token}",
        }
      end

      def self.headers(custom_headers = {})
        default_headers.merge(custom_headers)
      end
    end
  end
end
