module Moltin
  module Resources
    class Gateways < Resources::Base
      def update(slug, settings)
        response(call(:put, "#{uri}/#{slug}", data: settings))
      end

      def enable(slug)
        response(call(:put, "#{uri}/#{slug}", data: { enabled: true }))
      end

      def disable(slug)
        response(call(:put, "#{uri}/#{slug}", data: { enabled: false }))
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'gateway'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Gateway
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/gateways"
      end
    end
  end
end
