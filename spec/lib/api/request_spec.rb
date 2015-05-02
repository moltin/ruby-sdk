require 'moltin/api/request'

describe Moltin::Api::Request do

  describe "#self.get" do
    it "calls the correct methods" do
      expect(Moltin::Api::Client).to receive(:get).with('some-resource', {'X-Test' => '1'})
      described_class.get('some-resource', {'X-Test' => '1'})
    end
  end

end
