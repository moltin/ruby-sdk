require 'moltin/api/client'

module Moltin
  module Api
    class Request

      def self.get(path, custom_headers = {})
        Moltin::Api::Client.get(path, custom_headers)
      end

      def self.post(path, data, custom_headers = {})
        Moltin::Api::Client.post(path, data, custom_headers)
      end

    end
  end
end
