require 'moltin/api/response'

describe Moltin::Api::Response do

  let(:rest_client_response) { double('RestClient::Response') }

  describe "#initialize" do
    it do
      response = Moltin::Api::Response.new rest_client_response
      expect(response.instance_variable_get('@response')).to eq rest_client_response
    end
  end

  describe "#code" do
    it do
      response = Moltin::Api::Response.new rest_client_response
      expect(rest_client_response).to receive(:code).and_return 404
      expect(response.code).to eq 404
    end
  end

  describe "#code" do
    codes = {
      200 => true,
      201 => true,
      302 => true,
      401 => false,
      404 => false,
      500 => false,
      513 => false,
    }
    codes.each do |code, success|
      context code.to_s do
        it do
          response = Moltin::Api::Response.new rest_client_response
          expect(response).to receive_message_chain(:code).and_return code
          expect(response.success?).to eq success
        end
      end
    end
  end

  describe "#body" do
    it do
      response = Moltin::Api::Response.new rest_client_response
      expect(rest_client_response).to receive(:to_s).and_return 'text'
      expect(response.body).to eq 'text'
    end
  end

  describe "#as_hash" do
    it do
      response = Moltin::Api::Response.new rest_client_response
      expect(rest_client_response).to receive(:to_s).and_return '{"key":"value"}'
      expect(JSON).to receive(:parse).with('{"key":"value"}').and_return 'key' => 'value'
      expect(response.as_hash).to eq 'key' => 'value'
    end
  end

  describe "#result" do
    it do
      response = Moltin::Api::Response.new rest_client_response
      expect(response).to receive(:as_hash).and_return 'result' => 'some result data'
      expect(response).to receive(:code).and_return 200
      expect(response.result).to eq 'some result data'
    end
  end

end
