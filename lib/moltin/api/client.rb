require 'moltin/config'
require 'moltin/api/response'
require 'rest-client'

module Moltin
  module Api
    class Client
      @authenticated_until = nil
      @access_token = nil

      class << self
        attr_accessor :authenticated_until
        attr_accessor :access_token
      end

      def self.authenticate(grant_type = nil, options = {})
        grant_type ||= 'client_credentials'
        data = {
          grant_type: grant_type,
          client_id: options[:client_id] || ENV['MOLTIN_CLIENT_ID'],
          client_secret: options[:client_secret] || ENV['MOLTIN_CLIENT_SECRET']
        }

        headers = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }
        path    = "https://#{Moltin::Config.api_host}/oauth/access_token"
        request = RestClient::Resource.new(path, headers)

        request.post(data) do |response|
          json = JSON.parse(response.to_s)
          self.access_token = json['access_token']
          self.authenticated_until = expires_date(json['expires'].to_s)
        end
      end

      def self.authenticated?
        access_token && authenticated_until > DateTime.now
      end

      private

      def expires_date(date_string)
        return DateTime.strptime(date_string, '%s')
      rescue ArgumentError
        return DateTime.now
      end
    end
  end
end
