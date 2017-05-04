module Moltin
  module Resources
    class Settings < Resources::Base
      def update(data)
        data[:type] = type
        response(call(:put, uri, data: data))
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'settings'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Setting
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/settings"
      end
    end
  end
end
