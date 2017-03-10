module Moltin
  module Resources
    class Base
      attr_accessor :config, :storage

      def initialize(config, storage)
        @config = config
        @storage = storage
      end

      def all
        call(:get, uri)
      end

      def find(id)
        call(:get, "#{uri}/#{id}")
      end

      def create(data)
        call(:post, uri, data)
      end

      def update(id, data)
        call(:patch, "#{uri}/#{id}", data)
      end

      def delete(id)
        call(:delete, "#{uri}/#{id}")
      end

      private

      def uri
        raise 'Abstract Method.'
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
