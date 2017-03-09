require 'spec_helper'

RSpec.describe Moltin do
  it 'has a version number' do
    expect(Moltin::VERSION).not_to be nil
  end

  describe '#configure' do
    before do
      Moltin.configure do |config|
        config.client_id = 'client_id'
        config.client_secret = 'client_secret'
      end
    end

    it 'sets the client_id and client_secret' do
      client = Moltin::Client.new

      expect(client.config.client_id).to eq 'client_id'
      expect(client.config.client_secret).to eq 'client_secret'
    end
  end
end
