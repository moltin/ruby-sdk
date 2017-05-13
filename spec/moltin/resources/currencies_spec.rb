require 'spec_helper'

module Moltin
  module Resources
    describe Currencies do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }

      describe '#uri' do
        it 'returns the expected uri' do
          currency = Moltin::Resources::Currencies.new(config, {})
          expect(currency.send(:uri)).to eq 'v2/currencies'
        end
      end

      describe '#all' do
        it 'receives the list of currencies', freeze_time: true do
          VCR.use_cassette('resources/currencies/all') do
            response = client.currencies.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Currency)
            expect(response.response_links).not_to be_nil
            expect(response.included).to be_kind_of Moltin::Models::Included
            expect(response.response_meta).not_to be_nil

            expect(response.data.length).to eq 6
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes', freeze_time: true do
          VCR.use_cassette('resources/currencies/attributes') do
            resource = Moltin::Resources::Currencies.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(
              ['Type', 'Id', 'Code', 'Exchange Rate', 'Format', 'Decimal Point',
               'Thousand Separator', 'Decimal Places', 'Default', 'Enabled']
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given currency', freeze_time: true do
          VCR.use_cassette('resources/currencies/get') do
            resource = Moltin::Resources::Currencies.new(config, {})
            currency = resource.all.data.first
            response = resource.get(currency.id)

            expect(response.data.id).to eq currency.id
            expect(response.data).to be_kind_of(Moltin::Models::Currency)
          end
        end
      end

      describe '#create' do
        context 'valid currency' do
          it 'creates a new currency', freeze_time: true do
            VCR.use_cassette('resources/currencies/create/valid') do
              response = client.currencies.create(code: 'ABC',
                                                  exchange_rate: 1,
                                                  format: '${price}',
                                                  decimal_point: '.',
                                                  thousand_separator: ',',
                                                  decimal_places: 0,
                                                  default: false,
                                                  enabled: true)

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Currency)

              response = client.currencies.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid currency' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/currencies/create/invalid') do
              response = client.currencies.create(exchange_rate: 1,
                                                  format: '£{price}',
                                                  decimal_point: '.',
                                                  thousand_separator: ',',
                                                  decimal_places: 0,
                                                  default: false,
                                                  enabled: true)

              expect(response.errors).to eq(
                [{ 'source' => 'code', 'title' => 'required', 'detail' => 'code is required' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid currency' do
          it 'updates a new currency', freeze_time: true do
            VCR.use_cassette('resources/currencies/update/valid') do
              response = client.currencies.create(code: 'ABC',
                                                  exchange_rate: 1,
                                                  format: '£{price}',
                                                  decimal_point: '.',
                                                  thousand_separator: ',',
                                                  decimal_places: 0,
                                                  default: false,
                                                  enabled: true)

              id = response.data.id
              response = client.currencies.update(id, exchange_rate: 2)

              expect(response.data.exchange_rate).to eq 2
              expect(response.data).to be_kind_of(Moltin::Models::Currency)

              response = client.currencies.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid currency' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/currencies/update/invalid') do
              response = client.currencies.create(code: 'ABC',
                                                  exchange_rate: 1,
                                                  format: '£{price}',
                                                  decimal_point: '.',
                                                  thousand_separator: ',',
                                                  decimal_places: 0,
                                                  default: false,
                                                  enabled: true)

              id = response.data.id
              response = client.currencies.update(id, exchange_rate: nil)

              expect(response.errors).to eq(
                [{ 'source' => 'data.exchange_rate',
                   'title' => 'invalid_type',
                   'detail' => 'Invalid type. Expected: number, given: null' }]
              )

              response = client.currencies.delete(id)
              expect(response.data.id).to eq id
            end
          end
        end
      end

      describe '#delete' do
        it 'deletes the currency', freeze_time: true do
          VCR.use_cassette('resources/currencies/delete') do
            response = client.currencies.create(code: 'ABC',
                                                exchange_rate: 1,
                                                format: '£{price}',
                                                decimal_point: '.',
                                                thousand_separator: ',',
                                                decimal_places: 0,
                                                default: false,
                                                enabled: true)

            id = response.data.id
            response = client.currencies.delete(id)
            expect(response.data.id).to eq id

            response = client.currencies.get(id)
            expect(response.errors).to eq([{ 'code' => '2', 'title' => 'Currency not found' }])
          end
        end
      end
    end
  end
end
