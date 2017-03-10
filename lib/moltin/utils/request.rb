module Moltin
  module Utils
    class Request
      def initialize(base_url)
        @base_url = base_url
      end

      # Public: Call the Moltin API passing the credentials to retrieve a valid
      # access_token
      #
      # Raises an Errors::AuthenticationError if the call fails.
      # Returns a valid access_token if the credentials were valid.
      def authenticate(uri:, id:, secret:)
        body = post(uri: "/#{uri}", body: {
                      grant_type: 'client_credentials',
                      client_id: id,
                      client_secret: secret
                    })
        raise Errors::AuthenticationError unless body['access_token']

        body
      end

      def call(method, uri:, data: nil, token: nil, auth: true, conn: new_conn)
        conn.authorization :Bearer, token if auth && token

        options = { uri: uri, conn: conn }
        options[:body] = data if data
        send method, options
      end

      def get(uri:, conn: new_conn)
        JSON.parse(conn.get(uri).body)
      end

      def post(uri:, body:, conn: new_conn)
        JSON.parse(conn.post(uri, body).body)
      end

      def patch(uri:, body:, conn: new_conn)
        JSON.parse(conn.patch(uri, body).body)
      end

      def delete(uri:, conn: new_conn)
        JSON.parse(conn.delete(uri).body)
      end

      private

      def new_conn
        @conn = Faraday.new(url: @base_url)
      end
    end
  end
end
