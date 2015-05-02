require 'moltin/api/client'

describe Moltin::Api::Client do

  describe "#self.get" do
    it "calls the correct methods" do
      expect(described_class).to receive(:build_endpoint).and_return "http://moltinapi.dev/v1.0/some-resource"
      expect(described_class).to receive(:headers).and_return({"Authorization" => "Bearer XXXXX"})
      rest_client_request = double('RestClient::Resource')
      expect(rest_client_request).to receive(:get).and_return double('Moltin::Api::Response.new')
      expect(RestClient::Resource).to receive(:new).with("http://moltinapi.dev/v1.0/some-resource", instance_of(Hash)).and_return rest_client_request
      described_class.get('some-resource')
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
