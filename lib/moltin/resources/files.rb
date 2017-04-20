module Moltin
  module Resources
    class Files < Resources::Base
      def create(file, data = {})
        file = download_file(file) if file =~ /\A#{URI.regexp(%w(http https))}\z/
        response = request.post_file(uri: uri,
                                     token: access_token.get,
                                     file: file,
                                     data: data)
        response = { status: response.status, body: JSON.parse(response.body) }
        Moltin::Utils::Response.new(model_name, response)
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

      def download_file(url)
        download = open(url)
        file = "/tmp/#{download.base_uri.to_s.split('/')[-1]}}"
        IO.copy_stream(download, file)
        file
      end
    end
  end
end
