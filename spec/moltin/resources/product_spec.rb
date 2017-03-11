require 'spec_helper'

module Moltin
  module Resources
    describe Products do
      let(:config) { Configuration.new }

      before do
        ENV['MOLTIN_CLIENT_ID'] = ENV['FAKE_CLIENT_ID']
        ENV['MOLTIN_CLIENT_SECRET'] = 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'
      end

      after do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_ID')
      end

      describe '#uri' do
        it 'returns the expected uri' do
          product = Moltin::Resources::Products.new(config, {})
          expect(product.send(:uri)).to eq 'v2/products'
        end
      end

      describe '#all' do
        it 'receives the list of products' do
          VCR.use_cassette('resources/products/all') do
            resource = Moltin::Resources::Products.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.links).not_to be_nil
            expect(response.included).to be_nil
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 68
          end
        end
      end
    end
  end
end
