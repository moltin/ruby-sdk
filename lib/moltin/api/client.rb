require 'moltin/config'
require 'moltin/api/response'
require 'rest-client'

module Moltin
  module Api
    class Client

      @@authenticated_until = nil
      @@access_token = nil

      class << self
        attr_accessor :authenticated_until
        attr_accessor :access_token
      end

      def self.get(path, custom_headers = {})
        request = RestClient::Resource.new(
          build_endpoint(path),
          {
            verify_ssl: OpenSSL::SSL::VERIFY_NONE,
            headers: headers(custom_headers),
          }
        )
        request.get do |response, request, result|
          Moltin::Api::Response.new response
        end
      end

      def self.authenticate(grant_type = nil, options = {})
        grant_type ||= 'client_credentials'
        data ={
          grant_type: grant_type,
          client_id: options[:client_id] || ENV['MOLTIN_CLIENT_ID'],
          client_secret: options[:client_secret] || ENV['MOLTIN_CLIENT_SECRET'],
        }
        request = RestClient::Resource.new(
          "https://#{Moltin::Config.api_host}/oauth/access_token",
          {
            verify_ssl: OpenSSL::SSL::VERIFY_NONE,
          }
        )
        response = request.post(data) do |response, request, result|
          json = JSON.parse(response.to_s)
          self.access_token = json['access_token']
          self.authenticated_until = DateTime.strptime(json['expires'].to_s, '%s')
        end
      end

      def self.authenticated?
        @@access_token && @@authenticated_until > DateTime.now
      end

      private

      def self.build_endpoint(path)
        "https://#{Moltin::Config.api_host}/#{Moltin::Config.api_version}/#{path}"
      end

      def self.default_headers
        {
          'Authorization' => "Bearer #{access_token}",
        }
      end

      def self.headers(custom_headers = {})
        default_headers.merge(custom_headers)
      end

    end
  end
end
