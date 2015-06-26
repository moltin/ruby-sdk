require 'moltin/api/request'
require 'moltin/api/rest_client_wrapper'

class Moltin::Api::RestClientWrapper
  def initialize(path, custom_headers = {})
    @instance = RestClient::Resource.new(
      Moltin::Api::Request.build_endpoint(path),
      {
        verify_ssl: OpenSSL::SSL::VERIFY_NONE,
        headers: Moltin::Api::Request.headers(custom_headers),
      }
    )
  end

  def get
    @instance.get do |response|
      yield response
    end
  end

  def post data
    @instance.post data do |response|
      yield response
    end
  end

  def delete
    @instance.delete do |response|
      yield response
    end
  end
end
