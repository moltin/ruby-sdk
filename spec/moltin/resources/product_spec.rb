require 'spec_helper'

module Moltin
  module Resources
    describe Product do
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
          product = Moltin::Resources::Product.new(config, {})
          expect(product.send(:uri)).to eq 'v2/products'
        end
      end

      describe '#all' do
        it 'receives the list of products' do
          VCR.use_cassette('resources/products/all') do
            resource = Moltin::Resources::Product.new(config, {})

            expect(resource.all).to eq(
              'data' => [],
              'meta' => {
                'counts' => {
                  'matching_resource_count' => 0
                }
              }
            )
          end
        end
      end
    end
  end
end
