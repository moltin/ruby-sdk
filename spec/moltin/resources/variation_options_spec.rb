require 'spec_helper'

module Moltin
  module Resources
    describe VariationOptions do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }
      let(:variation) { client.variations.all.first }

      describe '#uri' do
        it 'returns the expected uri' do
          variation = Moltin::Resources::VariationOptions.new(config, {}, variation_id: 1)
          expect(variation.send(:uri)).to eq 'v2/variations/1/variation-options'
        end
      end

      describe '#create' do
        context 'valid variation' do
          it 'creates a new variation option', freeze_time: true do
            VCR.use_cassette('resources/variation-options/create/valid') do
              response = variation.variation_options.create(name: 'My VariationOption',
                                                            description: 'Cool description')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Variation)
              expect(response.data.options.first).to be_kind_of(Moltin::Models::VariationOption)

              response = variation.variation_options.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid variation' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/variation-options/create/invalid') do
              response = variation.variation_options.create(description: 'my-variation1')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid variation' do
          it 'updates a new variation', freeze_time: true do
            VCR.use_cassette('resources/variation-options/update/valid') do
              response = variation.variation_options.create(name: 'My VariationOption',
                                                            description: 'Cool description')
              id = response.data.options.first.id
              response = variation.variation_options.update(id, name: 'My New VariationOption')

              expect(response.data.options.first.name).to eq 'My New VariationOption'
              expect(response.data.options.first).to be_kind_of(Moltin::Models::VariationOption)

              variation.variation_options.delete(response.data.options.first.id)
            end
          end
        end
      end

      describe '#delete' do
        it 'deletes the variation', freeze_time: true do
          VCR.use_cassette('resources/variation-options/delete') do
            response = variation.variation_options.create(name: 'My VariationOption',
                                                          description: 'Cool description')
            id = response.data.id
            response = variation.variation_options.delete(id)
            expect(response.data.id).to eq id
          end
        end
      end
    end
  end
end
