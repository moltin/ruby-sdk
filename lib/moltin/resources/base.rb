module Moltin
  module Resources
    class Base
      attr_accessor :config, :storage

      def initialize(config, storage)
        @config = config
        @storage = storage
      end

      # Public: Load all the entities of the given type (specified in child class)
      # and instantiate the appropriate model for each one of them.
      #
      # Returns a Moltin::Utils::Response
      def all
        criteria.all
      end

      def limit(args)
        criteria.limit(args)
      end

      def offset(args)
        criteria.offset(args)
      end

      def order(args)
        criteria.order(args)
      end

      def where(args)
        criteria.where(args)
      end

      def includes(args)
        criteria.includes(args)
      end

      # Public: Load all the attributes for the given type
      #
      # Returns a Moltin::Utils::Response
      def attributes
        response(call(:get, "#{uri}/attributes"), model: Moltin::Models::Attribute)
      end

      # Public: Load the entity identified by the given id
      # and instantiate the appropriate model for it.
      #
      # id - the id of the resource to retrieve
      #
      # Returns a Moltin::Utils::Response
      def get(id)
        response(call(:get, "#{uri}/#{id}"))
      end

      # Public: Create a new entity in the Moltin store using the given data
      # parameter.
      #
      # data - a hash containing the data of the new resource
      #
      # Returns a Moltin::Utils::Response
      def create(data)
        data[:type] = type
        response(call(:post, uri, data: data))
      end

      # Public: Update an existing entity in the Moltin store using the specified
      # id and the given data parameter.
      #
      # id - the id of the resource to update
      # data - a hash containing the fields to update
      #
      # Returns a Moltin::Utils::Response
      def update(id, data)
        data[:type] = type
        data[:id] = id
        response(call(:put, "#{uri}/#{id}", data: data))
      end

      # Public: Delete an entity from the Moltin store
      #
      # id - the id of the resource to delete
      #
      # Returns a Moltin::Utils::Response
      def delete(id)
        response(call(:delete, "#{uri}/#{id}"))
      end

      def load_collection(formatted_uri, query_params)
        response(call(:get, formatted_uri, query_params: query_params))
      end

      private

      def uri
        raise 'Abstract Method.'
      end

      def criteria
        @critera ||= Moltin::Utils::Criteria.new(self, uri)
      end

      # Private: Instantiate a Moltin::Utils::Response based on the response
      # from the server
      #
      # resp - the response body from the API
      # model: (optional) - the name of the model to use to instantiate the response resources
      #
      # Returns a Moltin::Utils::Response
      def response(resp, model: model_name)
        Moltin::Utils::Response.new(model, resp)
      end

      # Private: Prepare a request payload before using a Moltin::Utils::Request
      # instance to make the call
      #
      # method - HTTP method (:get, :post, :put, :delete)
      # uri - the URI to call
      # data: (optional) - data to send
      #
      # Returns the body of the response as JSON
      def call(method, uri, data: nil, query_params: nil)
        options = { uri: uri, auth: authentication_required? }
        options[:token] = access_token.get if authentication_required?
        options[:data] = { data: data } if data
        options[:query_params] = query_params if query_params

        @request.call(method, options)
      end

      # Private: Instantiate a new Moltin::Utils::Request with the current config
      #
      # Returns a memoized instance of Moltin::Utils::Request
      def request
        @request ||= Moltin::Utils::Request.new(config.base_url)
      end

      # Private: Instantiate a new Moltin::Utils::AccessToken with the current config
      #
      # Returns a memoized instance of Moltin::Utils::AccessToken
      def access_token
        @access_token ||= Moltin::Utils::AccessToken.new(config, storage, request)
      end

      # Private: Check if authentication is needed for the current resource class
      #
      # Returns true or false
      def authentication_required?
        true
      end
    end
  end
end
