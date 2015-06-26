require 'moltin/api/request'
require 'moltin/api/response'
require 'moltin/api/rest_client_wrapper'

describe Moltin::Api::Request do

  describe "#self.get" do
    it "calls the correct methods" do
      api_response = double('Moltin::Api::Response.new')
      expect(Moltin::Api::Response).to receive(:new).with api_response
      rest_client_wrapper = double('Moltin::Api::RestClientWrapper')
      expect(rest_client_wrapper).to receive(:get).and_yield api_response
      expect(Moltin::Api::RestClientWrapper).to receive(:new).with('some-endpoint', 'custom_header' => 'value').and_return rest_client_wrapper
      Moltin::Api::Request.get('some-endpoint', 'custom_header' => 'value')
    end
  end

  describe "#self.post" do
    it "calls the correct methods" do
      data = { 'key' => 'value' }
      api_response = double('Moltin::Api::Response.new')
      expect(Moltin::Api::Response).to receive(:new).with api_response
      rest_client_wrapper = double('Moltin::Api::RestClientWrapper')
      expect(rest_client_wrapper).to receive(:post).with(data).and_yield api_response
      expect(Moltin::Api::RestClientWrapper).to receive(:new).with('some-endpoint', 'custom_header' => 'value').and_return rest_client_wrapper
      Moltin::Api::Request.post('some-endpoint', data, 'custom_header' => 'value')
    end
  end

  describe "#self.delete" do
    it "calls the correct methods" do
      api_response = double('Moltin::Api::Response.new')
      expect(Moltin::Api::Response).to receive(:new).with api_response
      rest_client_wrapper = double('Moltin::Api::RestClientWrapper')
      expect(rest_client_wrapper).to receive(:delete).and_yield api_response
      expect(Moltin::Api::RestClientWrapper).to receive(:new).with('some-endpoint', 'custom_header' => 'value').and_return rest_client_wrapper
      Moltin::Api::Request.delete('some-endpoint', 'custom_header' => 'value')
    end
  end

  describe "#build_endpoint" do
    before do
      expect(Moltin::Config).to receive(:api_host).and_return 'moltinapi.dev'
      expect(Moltin::Config).to receive(:api_version).and_return 'v4.2'
    end
    it "builds the endpoint" do
      expect(described_class.send(:build_endpoint, 'resource')).to eq "https://moltinapi.dev/v4.2/resource"
    end
  end

  describe "#self.default_headers" do
    it "returns a hash" do
      expect(described_class.send(:default_headers)).to be_instance_of(Hash)
    end
  end

  describe "#self.headers" do
    before do
      expect(described_class).to receive(:default_headers).and_return({'Bearer' => 'XXXXX'})
    end
    it "adds a new header" do
      expect(described_class.send(:headers, {'Currency' => 'GBP'})).to eq({'Bearer' => 'XXXXX', 'Currency' => 'GBP'})
    end
    it "overrides an existing header" do
      expect(described_class.send(:headers, {'Bearer' => 'TOKEN'})).to eq({'Bearer' => 'TOKEN'})
    end
  end

end
