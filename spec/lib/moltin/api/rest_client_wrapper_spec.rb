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

  describe "#get" do
    subject { described_class.new('some-endpoint') }
    it "delagates the block call back to Moltin::Api::Request" do
      instance = double('RestClient::Resource')
      expect(instance).to receive(:get).and_yield 'api_response'
      api_response = double('Moltin::Api::Response')
      expect(api_response).to receive(:new).with('api_response')
      subject.instance_variable_set('@instance', instance)
      subject.get { |response| api_response.new(response) }
    end
  end

  describe "#post" do
    subject { described_class.new('some-endpoint') }
    it "delagates the block call back to Moltin::Api::Request" do
      data = { 'key' => 'value' }
      instance = double('RestClient::Resource')
      expect(instance).to receive(:post).with(data).and_yield 'api_response'
      api_response = double('Moltin::Api::Response')
      expect(api_response).to receive(:new).with('api_response')
      subject.instance_variable_set('@instance', instance)
      subject.post(data) { |response| api_response.new(response) }
    end
  end

  describe "#delete" do
    subject { described_class.new('some-endpoint') }
    it "delagates the block call back to Moltin::Api::Request" do
      instance = double('RestClient::Resource')
      expect(instance).to receive(:delete).and_yield 'api_response'
      api_response = double('Moltin::Api::Response')
      expect(api_response).to receive(:new).with('api_response')
      subject.instance_variable_set('@instance', instance)
      subject.delete { |response| api_response.new(response) }
    end
  end

end
