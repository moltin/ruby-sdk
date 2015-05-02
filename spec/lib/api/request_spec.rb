require 'moltin/api/request'

describe Moltin::Api::Request do

  describe "#self.get" do
    it "calls the correct methods" do
      expect(Moltin::Api::Request).to receive(:build_endpoint).and_return "http://moltinapi.dev/v1.0/some-resource"
      expect(Moltin::Api::Request).to receive(:headers).and_return({"Bearer" => "XXXXX"})
      expect(RestClient).to receive(:get).with("http://moltinapi.dev/v1.0/some-resource", {}, {"Bearer" => "XXXXX"})
      Moltin::Api::Request.get("/some-resource")
    end
  end

  describe "#build_endpoint" do
    before do
      expect(Moltin::Config).to receive(:api_host).and_return 'moltinapi.dev'
      expect(Moltin::Config).to receive(:api_version).and_return 'v4.2'
    end
    it "builds the endpoint" do
      expect(Moltin::Api::Request.send(:build_endpoint, '/resource')).to eq "https://moltinapi.dev/v4.2/resource"
    end
  end

  describe "#self.default_headers" do
    it "returns a hash" do
      expect(Moltin::Api::Request.send(:default_headers)).to be_instance_of(Hash)
    end
  end

  describe "#self.headers" do
    before do
      expect(Moltin::Api::Request).to receive(:default_headers).and_return({'Bearer' => 'XXXXX'})
    end
    it "adds a new header" do
      expect(Moltin::Api::Request.send(:headers, {'Currency' => 'GBP'})).to eq({'Bearer' => 'XXXXX', 'Currency' => 'GBP'})
    end
    it "overrides an existing header" do
      expect(Moltin::Api::Request.send(:headers, {'Bearer' => 'TOKEN'})).to eq({'Bearer' => 'TOKEN'})
    end
  end

end
