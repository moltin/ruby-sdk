module Moltin
  class Resource
    attr_accessor :config, :storage

    def initialize(config, storage)
      @config = config
      @storage = storage
    end

    # Public: Retrieve the access_token from storage or from the API
    #
    # Returns a valid access_token if the credentials were valid
    def get_access_token
      auth = storage['authentication']
      return auth['access_token'] if auth && auth['expires'] > Time.now.to_i

      auth = authenticate_client
      storage['authentication'] = auth
      auth['access_token']
    end

    # Public: Call the Moltin API passing the credentials to retrieve a valid
    # access_token
    #
    # Raises an Errors::AuthenticationError if the call fails.
    # Returns a valid access_token if the credentials were valid.
    def authenticate_client
      body = {
        grant_type: 'client_credentials',
        client_id: @config.client_id,
        client_secret: @config.client_secret
      }
      response = Faraday.new(url: @config.base_url).post("/#{@config.auth_uri}", body)

      body = JSON.parse(response.body)
      raise Errors::AuthenticationError unless body['access_token']

      body
    end
  end
end
