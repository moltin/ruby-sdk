require 'moltin/api/request'
require 'moltin/api/rest_client_wrapper'

describe Moltin::Api::RestClientWrapper do

  describe "#initialize" do
    it do
      expect(Moltin::Api::Request).to receive(:build_endpoint).and_return "http://moltinapi.dev/v1.0/some-resource"
      expect(Moltin::Api::Request).to receive(:headers).and_return({"Authorization" => "Bearer XXXXX"})
      rest_client_request = double('RestClient::Resource')
      expect(RestClient::Resource).to receive(:new).with("http://moltinapi.dev/v1.0/some-resource", instance_of(Hash)).and_return rest_client_request
      described_class.new('some-resource', 'custom_header' => 'value')
    end
  end

end
