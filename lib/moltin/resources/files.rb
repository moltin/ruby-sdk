module Moltin
  module Resources
    class Files < Resources::Base
      def create(data)
        data[:type] = type
        response(call(:post, uri, data: data, json: false))
      end

      def update(_id, _data)
        raise Errors::UnsupportedActionError.new(
          'Files are immutable and therefore cannot be updated. ' \
          'See https://moltin.api-docs.io/v2/files/file.'
        )
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'file'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::File
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/files"
      end
    end
  end
end
