module Moltin
  module Resources
    class Entries < Resources::Base
      private

      # Private: Gives the type of the current Resources class.
      def type
        'entry'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Entry
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/flows/#{options[:flow_slug]}/entries"
      end
    end
  end
end
