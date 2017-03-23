module Moltin
  module Utils
    class AccessToken
      attr_accessor :config, :storage, :request

      def initialize(config, storage, request)
        @config = config
        @storage = storage
        @request = request
      end

      # Public: Retrieve the access_token from storage or from the API
      #
      # Returns a valid access_token if the credentials were valid
      def get
        auth = storage['authentication']
        return auth['access_token'] if auth && auth['expires'] > Time.now.to_i

        auth = request.authenticate(uri: config.auth_uri,
                                    id: config.client_id,
                                    secret: config.client_secret)

        storage['authentication'] = auth
        auth['access_token']
      end
    end
  end
end
