require 'spec_helper'

module Moltin
  describe Resource do
    let(:config) { Moltin::Configuration.new }

    describe '#initialize' do
      it 'sets config and storage' do
        storage = { test: '123' }
        resource = Moltin::Resource.new(config, storage)

        expect(resource.config).to eq config
        expect(resource.storage).to eq storage
      end
    end

    describe '#get_access_token' do
      before do
        ENV['MOLTIN_CLIENT_ID'] = 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc'
        ENV['MOLTIN_CLIENT_SECRET'] = 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'
      end

      after do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_ID')
      end

      context 'with auth info in storage' do
        context 'with valid token' do
          it 'returns the token' do
            storage = {
              'authentication' => {
                'access_token' => '123',
                'expires' => (Time.now + 24 * 60 * 60).to_i
              }
            }

            resource = Moltin::Resource.new(config, storage)
            expect(resource.get_access_token).to eq('123')
          end
        end

        context 'with expired token' do
          it 'returns the token' do
            VCR.use_cassette('authenticate/valid_expired') do
              storage = {
                'authentication' => {
                  'access_token' => '123',
                  'expires' => (Time.now - 24 * 60 * 60).to_i
                }
              }

              resource = Moltin::Resource.new(config, storage)
              expect(resource.get_access_token).not_to be_nil
              expect(resource.get_access_token).not_to eq('123')
            end
          end
        end
      end

      context 'without auth info in storage' do
        it 'requests a new token from the server' do
          VCR.use_cassette('authenticate/valid') do
            resource = Moltin::Resource.new(config, {})
            expect(resource.get_access_token).not_to be_nil
          end
        end
      end
    end

    describe '#authenticate_client' do
      after do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_ID')
      end

      context 'with valid credentials' do
        before do
          ENV['MOLTIN_CLIENT_ID'] = 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc'
          ENV['MOLTIN_CLIENT_SECRET'] = 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'
        end

        it 'receives the expected body' do
          VCR.use_cassette('authenticate/valid') do
            resource = Moltin::Resource.new(config, {})
            body = resource.authenticate_client

            expect(body['identifier']).to eq 'client_credentials'
            expect(body['token_type']).to eq 'Bearer'
            expect(body['access_token']).not_to be_nil
          end
        end
      end

      context 'with invalid credentials' do
        before do
          ENV['MOLTIN_CLIENT_ID'] = 'abc'
          ENV['MOLTIN_CLIENT_SECRET'] = 'def'
        end

        it 'raises an error' do
          VCR.use_cassette('authenticate/invalid') do
            resource = Moltin::Resource.new(config, {})
            expect { resource.authenticate_client }.to(
              raise_error(Moltin::Errors::AuthenticationError)
            )
          end
        end
      end
    end
  end
end
