require 'moltin/api/client'
require 'moltin/api/rest_client_wrapper'
require 'moltin/support/authentication_error'

module Moltin
  module Api
    class Request
      def self.get(path, custom_headers = {})
        check_auth
        request = Moltin::Api::RestClientWrapper.new(path, custom_headers)
        request.get do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.post(path, data, custom_headers = {})
        check_auth
        request = Moltin::Api::RestClientWrapper.new(path, custom_headers)
        request.post data do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.put(path, data, custom_headers = {})
        check_auth
        request = Moltin::Api::RestClientWrapper.new(path, custom_headers)
        request.put data do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.delete(path, custom_headers = {})
        check_auth
        request = Moltin::Api::RestClientWrapper.new(path, custom_headers)
        request.delete do |response|
          Moltin::Api::Response.new response
        end
      end

      def self.build_endpoint(path)
        "https://#{Moltin::Config.api_host}/#{Moltin::Config.api_version}/#{path}"
      end

      def self.default_headers
        {
          'Authorization' => "Bearer #{Moltin::Api::Client.access_token}"
        }
      end

      def self.headers(custom_headers = {})
        default_headers.merge(custom_headers)
      end

      def self.check_auth
        return if Moltin::Api::Client.authenticated?
        raise Moltin::Support::AuthenticationError
      end
    end
  end
end
