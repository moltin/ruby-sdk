require 'spec_helper'

module Moltin
  module Resources
    describe Gateways do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }

      before do
        ENV['MOLTIN_CLIENT_ID'] = ENV['FAKE_CLIENT_ID']
        ENV['MOLTIN_CLIENT_SECRET'] = ENV['FAKE_CLIENT_SECRET']
      end

      after do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_SECRET')
      end

      describe '#uri' do
        it 'returns the expected uri' do
          gateway = Moltin::Resources::Gateways.new(config, {})
          expect(gateway.send(:uri)).to eq 'v2/gateways'
        end
      end

      describe '#all' do
        it 'receives all the gateways', freeze_time: true do
          VCR.use_cassette('resources/gateways/all') do
            gateways = client.gateways.all.data
            expect(gateways[0]).to be_kind_of(Moltin::Models::Gateway)
            expect(gateways.length).to eq 3
          end
        end
      end

      describe '#get' do
        it 'receives the given gateway', freeze_time: true do
          VCR.use_cassette('resources/gateways/get') do
            gateway = client.gateways.get('stripe').data
            expect(gateway).to be_kind_of(Moltin::Models::Gateway)
          end
        end
      end

      describe '#update' do
        it 'updates the gateway', freeze_time: true do
          VCR.use_cassette('resources/gateways/update') do
            gateway = client.gateways.update('stripe', login: 'test').data
            expect(gateway.login).to eq 'test'
            expect(gateway).to be_kind_of(Moltin::Models::Gateway)
          end
        end
      end

      describe '#enable' do
        it 'enables the gateway', freeze_time: true do
          VCR.use_cassette('resources/gateways/enable') do
            gateway = client.gateways.enable('stripe').data
            expect(gateway.enabled).to eq true
            expect(gateway).to be_kind_of(Moltin::Models::Gateway)
          end
        end
      end

      describe '#disable' do
        it 'disables the gateway', freeze_time: true do
          VCR.use_cassette('resources/gateways/disable') do
            gateway = client.gateways.enable('stripe').data
            expect(gateway.enabled).to eq true
            gateway = client.gateways.disable('stripe').data
            expect(gateway.enabled).to eq false
          end
        end
      end
    end
  end
end
