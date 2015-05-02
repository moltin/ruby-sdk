require 'moltin/config'

describe Moltin::Config do

  describe "#attr_accessor" do

    describe "#api_version" do
      it "has default value" do
        expect(Moltin::Config.api_version).to eq '1.0'
      end
      it "can be updated" do
        Moltin::Config.api_version = '0.1'
        expect(Moltin::Config.api_version).to eq '0.1'
      end
    end

    describe "#api_client_id" do
      it "has no default value" do
        expect(Moltin::Config.api_client_id).to eq nil
      end
      it "can be updated" do
        Moltin::Config.api_client_id = 'XXXXX'
        expect(Moltin::Config.api_client_id).to eq 'XXXXX'
      end
    end

    describe "#api_client_secret" do
      it "has no default value" do
        expect(Moltin::Config.api_client_secret).to eq nil
      end
      it "can be updated" do
        Moltin::Config.api_client_secret = 'XXXXX'
        expect(Moltin::Config.api_client_secret).to eq 'XXXXX'
      end
    end

  end

end
