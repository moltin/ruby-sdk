require 'spec_helper'

module Moltin
  module Utils
    describe Request do
      let(:request) { Moltin::Utils::Request.new('https://api.moltin.com') }
      let(:conn) { Faraday.new(url: 'https://api.moltin.com') }

      describe '#authenticate' do
        context 'with valid credentials' do
          it 'receives the expected body' do
            VCR.use_cassette('utils/request/valid') do
              body = request.authenticate(uri: 'oauth/access_token',
                                          id: ENV['FAKE_CLIENT_ID'],
                                          secret: ENV['FAKE_CLIENT_SECRET'])

              expect(body['identifier']).to eq 'client_credentials'
              expect(body['token_type']).to eq 'Bearer'
              expect(body['access_token']).not_to be_nil
            end
          end
        end

        context 'with invalid credentials' do
          it 'raises an error' do
            VCR.use_cassette('utils/request/invalid') do
              expect do
                request.authenticate(uri: 'oauth/access_token',
                                     id: '123',
                                     secret: 'abc')
              end.to(
                raise_error(Moltin::Errors::AuthenticationError)
              )
            end
          end
        end
      end

      describe '#call' do
        context 'get' do
          it 'calls the #get method' do
            expect(request).to receive(:get).with(uri: '/test', conn: conn)
            request.call(:get, uri: '/test', conn: conn)
          end

          context 'with auth & token' do
            it 'calls the #get with the token parameter' do
              expect(request).to receive(:get).with(uri: '/test', conn: conn)
              request.call(:get, uri: '/test', token: '123', conn: conn)
              expect(conn.headers['Authorization']).to eq 'Bearer 123'
            end
          end

          context 'with !auth & token' do
            it 'calls the #get without the token parameter' do
              expect(request).to receive(:get).with(uri: '/test', conn: conn)
              request.call(:get, uri: '/test', token: '123', auth: false, conn: conn)
            end
          end
        end

        context 'post' do
          it 'calls the #post method' do
            expect(request).to receive(:post).with(uri: '/test', body: {}, conn: conn)
            request.call(:post, uri: '/test', data: {}, conn: conn)
          end
        end

        context 'patch' do
          it 'calls the #patch method' do
            expect(request).to receive(:patch).with(uri: '/test', body: {}, conn: conn)
            request.call(:patch, uri: '/test', data: {}, conn: conn)
          end
        end

        context 'delete' do
          it 'calls the #delete method' do
            expect(request).to receive(:delete).with(uri: '/test', conn: conn)
            request.call(:delete, uri: '/test', conn: conn)
          end
        end
      end
    end
  end
end
