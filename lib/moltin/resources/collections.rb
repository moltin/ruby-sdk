module Moltin
  module Resources
    class Collections < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'collection'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Collection
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/collections"
      end
    end
  end
end
