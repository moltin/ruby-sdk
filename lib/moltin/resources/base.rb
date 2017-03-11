module Moltin
  module Resources
    class Base
      attr_accessor :config, :storage

      def initialize(config, storage)
        @config = config
        @storage = storage
      end

      def all
        response(call(:get, uri))
      end

      def attributes
        response(call(:get, "#{uri}/attributes"), model: Moltin::Models::Attribute)
      end

      def find(id)
        response(call(:get, "#{uri}/#{id}"))
      end

      def create(data)
        data[:type] = type
        response(call(:post, uri, { data: data }))
      end

      def update(id, data)
        data[:type] = type
        data[:id] = id
        response(call(:put, "#{uri}/#{id}", { data: data }))
      end

      def delete(id)
        response(call(:delete, "#{uri}/#{id}"))
      end

      private

      def uri
        raise 'Abstract Method.'
      end

      def response(resp, model: model_name)
        Moltin::Utils::Response.new(model, resp)
      end

      def call(method, uri, data = nil)
        options = { uri: uri, auth: authentication_required? }
        options[:token] = access_token.get if authentication_required?
        options[:data] = data if data

        @request.call(method, options)
      end

      def request
        @request ||= Moltin::Utils::Request.new(config.base_url)
      end

      def access_token
        @access_token ||= Moltin::Utils::AccessToken.new(config, storage, request)
      end

      def authentication_required?
        true
      end
    end
  end
end
