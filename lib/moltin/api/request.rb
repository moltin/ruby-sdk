require 'moltin/config'
require 'rest-client'

module Moltin
  module Api
    class Request

      def self.get(path, custom_headers = {})
        RestClient.get(build_endpoint(path), {}, headers(custom_headers))
      end

      private

      def self.build_endpoint(path)
        "https://#{Moltin::Config.api_host}/#{Moltin::Config.api_version}#{path}"
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
