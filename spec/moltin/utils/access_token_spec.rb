require 'spec_helper'

module Moltin
  module Utils
    describe AccessToken do
      let(:config) { Moltin::Configuration.new }
      let(:storage) { {} }
      let(:request) { Moltin::Utils::Request.new('https://api.moltin.com') }
      let(:access_token) { Moltin::Utils::AccessToken.new(config, storage, request) }

      describe '#initialize' do
        it 'sets config, storage and request' do
          storage = { test: '123' }
          access_token = described_class.new(config, storage, request)

          expect(access_token.config).to eq config
          expect(access_token.storage).to eq storage
          expect(access_token.request).to eq request
        end
      end

      describe '#get' do
        before do
          ENV['MOLTIN_CLIENT_ID'] = ENV['FAKE_CLIENT_ID']
          ENV['MOLTIN_CLIENT_SECRET'] = ENV['FAKE_CLIENT_SECRET']
        end

        after do
          ENV.delete('MOLTIN_CLIENT_ID')
          ENV.delete('MOLTIN_CLIENT_ID')
        end

        context 'with auth info in storage' do
          context 'with valid token' do
            let(:storage) do
              {
                'authentication' => {
                  'access_token' => '123',
                  'expires' => (Time.now + 24 * 60 * 60).to_i
                }
              }
            end

            it 'returns the token' do
              expect(access_token.get).to eq('123')
            end
          end

          context 'with expired token' do
            let(:storage) do
              {
                'authentication' => {
                  'access_token' => '123',
                  'expires' => (Time.now - 24 * 60 * 60).to_i
                }
              }
            end

            it 'returns a new token' do
              stub_request(:post, 'https://api.moltin.com/oauth/access_token').
                with(body: 'client_id=FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc' \
                           '&client_secret=iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc' \
                           '&grant_type=client_credentials',
                     headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
                to_return(body: '{"expires":1489137539,"identifier":' \
                                '"client_credentials","expires_in":3600,' \
                                '"access_token":"99c3bf207a7d090e01c4809626b3fa7d737f51fc",' \
                                '"token_type":"Bearer"}')

              expect(access_token.get).not_to eq('123')
              expect(access_token.get).to eq('99c3bf207a7d090e01c4809626b3fa7d737f51fc')
            end
          end
        end

        context 'without auth info in storage' do
          it 'requests a new token from the server' do
            VCR.use_cassette('utils/access_tokens/new') do
              expect(access_token.get).not_to be_nil
            end
          end
        end
      end
    end
  end
end
