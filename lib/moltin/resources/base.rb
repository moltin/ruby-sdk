module Moltin
  module Resources
    class Base
      attr_accessor :config, :storage, :options, :client, :criteria

      def initialize(config, options = {}, client = nil)
        @client = client
        @config = config
        @storage = @config.storage || {}
        @options = options
      end

      # Public: Get a criteria and call the #all method on it
      #
      # Returns a Moltin::Utils::Criteria
      def all
        criteria = Moltin::Utils::Criteria.new(self, uri)
        criteria.all
      end

      # Public: Get a criteria and call the #limit method on it
      #
      # args - the number of records wanted (Example: 10)
      #
      # Returns a Moltin::Utils::Criteria
      def limit(args)
        check_criteria
        criteria.limit(args)
      end

      # Public: Get a criteria and call the #offset method on it
      #
      # args - the offset of records wanted (Example: 10)
      #
      # Returns a Moltin::Utils::Criteria
      def offset(args)
        check_criteria
        criteria.offset(args)
      end

      # Public: Get a criteria and call the #sort method on it
      #
      # args - the sort parameter (Example: 'name' or '-name')
      #
      # Returns a Moltin::Utils::Criteria
      def sort(args)
        check_criteria
        criteria.sort(args)
      end

      # Public: Get a criteria and call the #filter method on it
      #
      # args - a hash of filter options as specified in the API docs
      # Example: { has: { name: 'value' } }
      #
      # Returns a Moltin::Utils::Criteria
      def filter(args)
        check_criteria
        criteria.filter(args)
      end

      # Public: Get a criteria and call the #with method on it
      #
      # args - A list of resource types to include
      # Example: with(:brands, :categories)
      #
      # Returns a Moltin::Utils::Criteria
      def with(*args)
        check_criteria
        criteria.with(args)
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
        criteria = Moltin::Utils::Criteria.new(self, "#{uri}/#{id}")
        criteria.get
      end

      # Public: Create a new entity in the Moltin store using the given data
      # parameter.
      #
      # data - a hash containing the data of the new resource
      #
      # Returns a Moltin::Utils::Response
      def create(data)
        data[:type] ||= type
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

      # Public: Load all the entities of the given type (specified in child class)
      # and instantiate the appropriate model for each one of them.
      #
      # Returns a Moltin::Utils::Response
      def load_collection(formatted_uri, query_params)
        response(call(:get, formatted_uri, query_params: query_params))
      end

      def create_relationships(id, relationship_type, relationship_ids)
        handle_relationship_call(:post, id, relationship_type, relationship_ids)
      end

      def update_relationships(id, relationship_type, relationship_ids = nil)
        handle_relationship_call(:put, id, relationship_type, relationship_ids)
      end

      def delete_relationships(id, relationship_type, relationship_ids = nil)
        handle_relationship_call(:delete, id, relationship_type, relationship_ids)
      end

      private

      def uri
        raise 'Abstract Method.'
      end

      def check_criteria
        unless criteria
          raise Errors::UndefinedCriteria.new(
            "Call 'all' or 'get' before calling limit, offset, sort, filter or with."
          )
        end
      end

      # Private: Instantiate a Moltin::Utils::Response based on the response
      # from the server
      #
      # resp - the response body from the API
      # model: (optional) - the name of the model to use to instantiate the response resources
      #
      # Returns a Moltin::Utils::Response
      def response(resp, model: model_name)
        Moltin::Utils::Response.new(model, resp, client)
      end

      # Private: Prepare a request payload before using a Moltin::Utils::Request
      # instance to make the call
      #
      # method - HTTP method (:get, :post, :put, :delete)
      # uri - the URI to call
      # data: (optional) - data to send
      # query_params: (optional) - a hash of query params
      #
      # Returns the body of the response as JSON
      def call(method, uri, data: nil, query_params: nil, content_type: nil)
        options = { uri: uri, auth: authentication_required? }
        options[:token] = access_token.get if authentication_required?
        options[:data] = { data: data } if data
        options[:query_params] = query_params if query_params
        options[:content_type] = content_type if content_type

        request.call(method, options)
      end

      # Private: Instantiate a new Moltin::Utils::Request with the current config
      #
      # Returns a memoized instance of Moltin::Utils::Request
      def request
        @request ||= Moltin::Utils::Request.new(config.base_url, currency_code: currency,
                                                                 language: config.language,
                                                                 locale: config.locale,
                                                                 logger: config.logger)
      end

      def currency
        if client && client.currency_code
          currency = client.currency_code
          client.currency_code = nil
        else
          currency = config.currency_code
        end

        currency
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

      def handle_relationship_call(method, id, relationship_type, relationship_ids)
        unless [model_name.has_many_list, model_name.belongs_list].flatten.compact.include?(relationship_type.to_sym)
          raise Errors::InvalidRelationshipError.new(
            "The relationship #{relationship_type} was not defined on #{model_name}." \
            "Available relationships: #{[model_name.has_many_list, model_name.belongs_list].flatten.compact.join(', ')}"
          )
        end

        response(call(method, "#{uri}/#{id}/relationships/#{relationship_type}",
                      data: format_relationships(relationship_type, relationship_ids)),
                 model: @config.resources[relationship_type.to_sym][:model])
      end

      def format_relationships(relationship_type, relationship_ids)
        return nil unless relationship_ids

        if model_name.has_many_list.include?(relationship_type.to_sym)
          [*relationship_ids].compact.map do |r_id|
            { type: @config.resources[relationship_type.to_s.tr('-', '_').to_sym][:name], id: r_id }
          end
        else
          { type: @config.resources[relationship_type.to_sym][:name], id: relationship_ids }
        end
      end

      def inspect; end
    end
  end
end
