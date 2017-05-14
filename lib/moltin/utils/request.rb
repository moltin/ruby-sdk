module Moltin
  module Utils
    class Request
      def initialize(base_url, currency_code: nil, language: nil, locale: nil, logger: nil)
        @base_url = base_url
        @currency_code = currency_code
        @language = language
        @locale = locale
        @logger = logger
      end

      # Public: Call the Moltin API passing the credentials to retrieve a valid
      # access_token
      #
      # Raises an Errors::AuthenticationError if the call fails.
      # Returns a valid access_token if the credentials were valid.
      def authenticate(uri:, id:, secret:)
        resp = post(uri: "/#{uri}", body: {
                      grant_type: 'client_credentials',
                      client_id: id,
                      client_secret: secret
                    }, content_type: 'application/x-www-form-urlencoded')
        body = JSON.parse(resp.body)
        raise Errors::AuthenticationError unless body['access_token']

        { status: resp.status, body: body }
      end

      # Public: Call the Moltin API with the given parameters.
      #
      # method - the HTTP method (:get, :post, :put, :delete)
      # uri: - the URI to call
      # data: - data to send to the server
      # query_params: - query params to send to the server
      # token: - the Bearer token
      # auth: - Boolean defining if auth is needed or not
      # conn: - a Faraday connection
      #
      # Returns the HTTP response from the API
      def call(method, uri:, data: nil, query_params: nil, token: nil,
               auth: true, conn: new_conn, content_type: nil)
        conn.authorization :Bearer, token if auth && token

        options = { uri: uri, conn: conn }
        options[:body] = data if data
        options[:query_params] = query_params if query_params
        options[:content_type] = content_type if content_type

        log_request(method, uri, options)
        resp = send(method, options)

        begin
          { status: resp.status, body: JSON.parse(resp.body) }
        rescue JSON::ParserError
          @logger.error "The response body could not be parsed as JSON: #{resp.status} - #{resp.body}" if @logger
          { status: resp.status, body: {} }
        end
      end

      # Public: Makes a GET request to the Moltin API
      #
      # uri: - the URI to call
      # query_params: - query params to send to the server
      # conn: - a Faraday connection
      #
      # Returns the body of the response as JSON
      def get(uri:, query_params: nil, conn: new_conn)
        conn.get do |req|
          set_headers(req)
          req.url uri
          req.params = query_params if query_params
        end
      end

      # Public: Makes a POST request to the Moltin API
      #
      # uri: - the URI to call
      # body: - The data to send
      # conn: - a Faraday connection
      # json: - If the request should be sent as application/json
      #
      # Returns the body of the response as JSON
      def post(uri:, body:, conn: new_conn, content_type: nil)
        content_type ||= 'application/json'

        conn.post do |req|
          set_headers(req)
          req.url uri
          req.headers['Content-Type'] = content_type
          req.body = content_type == 'application/json' ? body.to_json : body
        end
      end

      def post_file(uri:, token:, file:, data:)
        conn = Faraday.new(url: @base_url) do |f|
          f.request :multipart
          f.adapter :net_http
        end

        conn.authorization :Bearer, token

        data[:file] = Faraday::UploadIO.new(file, 'image/jpeg')
        conn.post(uri, data)
      end

      # Public: Makes a PUT request to the Moltin API
      #
      # uri: - the URI to call
      # body: - The data to send
      # conn: - a Faraday connection
      # json: - If the request should be sent as application/json
      #
      # Returns the body of the response as JSON
      def put(uri:, body:, conn: new_conn, content_type: nil)
        content_type ||= 'application/json'

        conn.put do |req|
          set_headers(req)
          req.url uri
          req.headers['Content-Type'] = content_type
          req.body = content_type == 'application/json' ? body.to_json : body
        end
      end

      # Public: Makes a DELETE request to the Moltin API
      #
      # uri: - the URI to call
      # conn: - a Faraday connection
      #
      # Returns the body of the response as JSON
      def delete(uri:, body: nil, conn: new_conn, content_type: nil)
        content_type ||= 'application/json'

        if body
          conn.delete do |req|
            set_headers(req)
            req.url uri
            req.headers['Content-Type'] = content_type
            req.body = content_type == 'application/json' ? body.to_json : body
          end
        else
          conn.delete do |req|
            set_headers(req)
            req.url uri
          end
        end
      end

      private

      def log_request(method, uri, options)
        if @logger
          @logger.info '*************************************'
          @logger.info "Moltin API Call: #{method.upcase} #{uri}"
          @logger.info '-------------------------------------'

          @logger.info 'Headers'
          @logger.info "X-MOLTIN-LANGUAGE=#{@language}" if @language
          @logger.info "X-MOLTIN-CURRENCY=#{@currency_code}" if @currency_code
          @logger.info "X-MOLTIN-LOCALE=#{@locale}" if @locale
          @logger.info '-------------------------------------'

          if options[:query_params]
            @logger.info 'Query Params'
            @logger.info options[:query_params]
            @logger.info '-------------------------------------'
          end

          if options[:body]
            @logger.info 'Body'
            @logger.info options[:body]
            @logger.info '-------------------------------------'
          end

          if options[:content_type]
            @logger.info 'Content-Type'
            @logger.info options[:content_type]
            @logger.info '-------------------------------------'
          end

          @logger.info '*************************************'
        end
      end

      def set_headers(req)
        req.headers['X-MOLTIN-LANGUAGE'] = @language if @language
        req.headers['X-MOLTIN-CURRENCY'] = @currency_code if @currency_code
        req.headers['X-MOLTIN-LOCALE'] = @locale if @locale
      end

      # Private: Instantiate a new Faraday connection
      #
      # Returns a Faraday conn object
      def new_conn
        @conn = Faraday.new(url: @base_url)
      end
    end
  end
end
