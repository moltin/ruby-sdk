module Moltin
  module Resources
    class Fields < Resources::Base
      def all(flow_slug = nil)
        response(call(:get, "#{@config.version}/flows/#{flow_slug || options[:flow_slug]}/fields"))
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'field'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Field
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/fields"
      end
    end
  end
end
