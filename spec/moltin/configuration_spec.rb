require 'spec_helper'

module Moltin
  describe Configuration do
    describe 'attributes' do
      describe 'pre-set ENV variables' do
        it 'uses the defined ENV variables' do
          ENV['MOLTIN_CLIENT_ID'] = 'id'
          ENV['MOLTIN_CLIENT_SECRET'] = 'secret'

          config = Configuration.new
          expect(config.client_id).to eq('id')
          expect(config.client_secret).to eq('secret')
        end
      end

      it 'can set value' do
        config = Configuration.new
        config.client_id = 'client_id'
        expect(config.client_id).to eq('client_id')
      end
    end

    describe '#initialize' do
      it 'sets all the values to their defaults' do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_SECRET')

        config = Configuration.new
        expect(config.client_id).to eq(nil)
        expect(config.client_secret).to eq(nil)
        expect(config.version).to eq('v2')
        expect(config.base_url).to eq('https://api.moltin.com')
        expect(config.auth_uri).to eq('oauth/access_token')
      end
    end

    describe '#[]' do
      it 'returns the request value' do
        expect(Configuration.new[:base_url]).to eq('https://api.moltin.com')
      end
    end

    describe '#to_hash' do
      it 'returns the configuration as a hash' do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_SECRET')

        expect(Configuration.new.to_hash).to eq(client_id: nil,
                                                client_secret: nil,
                                                base_url: 'https://api.moltin.com',
                                                currency_code: 'USD',
                                                language: 'en',
                                                locale: 'en_gb')
      end
    end

    describe '#merge' do
      it 'merges the given options' do
        config = Configuration.new
        config.merge(client_id: '123')
        expect(config.client_id).to eq('123')
      end
    end
  end
end
