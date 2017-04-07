module Moltin
  module Resources
    class Categories < Resources::Base
      def tree
        response(call(:get, "#{uri}/tree"))
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'category'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Category
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/categories"
      end
    end
  end
end
