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
          expect(config.client_id).not_to eq nil
          expect(config.client_secret).not_to eq nil
          expect(config.version).to eq('v2')
          expect(config.base_url).to eq('https://api.moltin.com')
          expect(config.auth_uri).to eq('oauth/access_token')
        end
      end
    end

    describe '#products' do
      it 'returns an instance of Moltin::Resources::Products' do
        expect(Moltin::Client.new.products).to be_kind_of(Moltin::Resources::Products)
      end
    end

    describe '#brands' do
      it 'returns an instance of Moltin::Resources::Brands' do
        expect(Moltin::Client.new.brands).to be_kind_of(Moltin::Resources::Brands)
      end
    end

    describe '#categories' do
      it 'returns an instance of Moltin::Resources::Categories' do
        expect(Moltin::Client.new.categories).to be_kind_of(Moltin::Resources::Categories)
      end
    end

    describe '#collections' do
      it 'returns an instance of Moltin::Resources::Collections' do
        expect(Moltin::Client.new.collections).to be_kind_of(Moltin::Resources::Collections)
      end
    end

    describe '#files' do
      it 'returns an instance of Moltin::Resources::Files' do
        expect(Moltin::Client.new.files).to be_kind_of(Moltin::Resources::Files)
      end
    end

    describe '#currency' do
      it 'sets the currency as instance variable' do
        client = Moltin::Client.new.currency('THB')
        expect(client.currency_code).to eq 'THB'
      end
    end
  end
end
