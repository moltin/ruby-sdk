require 'moltin/api/client'

module Moltin
  module Api
    class Request

      def self.get(path, custom_headers = {})
        Moltin::Api::Client.get(path)
      end

    end
  end
end
