require 'spec_helper'

module Moltin
  describe Client do
    describe '#initialize' do
      context 'with overriding options' do
        it 'overrides the values in the configuration' do
          config = Moltin::Client.new(client_id: 'id', client_secret: 'secret').config
          expect(config.client_id).to eq('id')
          expect(config.client_secret).to eq('secret')
          expect(config.version).to eq('v2')
          expect(config.base_url).to eq('https://api.moltin.com')
          expect(config.auth_uri).to eq('oauth/access_token')
        end
      end

      context 'without the options argument' do
        it 'loads the default configuration' do
          config = Moltin::Client.new.config
          expect(config.client_id).to eq(nil)
          expect(config.client_secret).to eq(nil)
          expect(config.version).to eq('v2')
          expect(config.base_url).to eq('https://api.moltin.com')
          expect(config.auth_uri).to eq('oauth/access_token')
        end
      end
    end

    describe '#products' do
      it 'returns an instance of Moltin::Resources::Product' do
        expect(Moltin::Client.new.products).to be_kind_of(Moltin::Resources::Product)
      end
    end
  end
end
