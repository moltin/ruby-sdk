require 'spec_helper'

module Moltin
  module Resources
    describe ProductModifiers do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }
      let(:variation) { client.variations.all.first }
      let(:option) { variation.options.first }

      describe '#uri' do
        it 'returns the expected uri' do
          modifier = Moltin::Resources::ProductModifiers.new(config, {}, variation_id: 1, option_id: 1)
          expect(modifier.send(:uri)).to eq 'v2/variations/1/variation-options/1/product-modifiers'
        end
      end

      describe '#create' do
        context 'valid variation' do
          it 'creates a new product modifier', freeze_time: true do
            VCR.use_cassette('resources/product-modifiers/create/valid') do
              response = option.product_modifiers.create(modifier_type: 'sku_builder',
                                                         value: {
                                                           seek: 'in incididunt cupidatat dolor est',
                                                           set: 'velit ad ut'
                                                         })

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Variation)
              expect(response.data.options.first.modifiers.first).to be_kind_of(Moltin::Models::ProductModifier)

              response = option.product_modifiers.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid variation' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/product-modifiers/create/invalid') do
              response = option.product_modifiers.create(modifier_type: 'sku_builder')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.value field is required.' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid variation' do
          it 'updates a new variation', freeze_time: true do
            VCR.use_cassette('resources/product-modifiers/update/valid') do
              response = option.product_modifiers.create(modifier_type: 'sku_builder',
                                                         value: {
                                                           seek: 'in incididunt cupidatat dolor est',
                                                           set: 'velit ad ut'
                                                         })
              id = response.data.options.first.modifiers.first.id
              response = option.product_modifiers.update(id, value: {
                                                           seek: 'in incididunt cupidatat dolor est!',
                                                           set: 'velit ad ut!'
                                                         })

              expect(response.data.options.first.modifiers.first.value).to eq(
                'seek' => 'in incididunt cupidatat dolor est!',
                'set' => 'velit ad ut!'
              )
              expect(response.data.options.first).to be_kind_of(Moltin::Models::VariationOption)

              option.product_modifiers.delete(response.data.id)
            end
          end
        end
      end

      describe '#delete' do
        it 'deletes the variation', freeze_time: true do
          VCR.use_cassette('resources/product-modifiers/delete') do
            response = option.product_modifiers.create(modifier_type: 'sku_builder',
                                                       value: {
                                                         seek: 'in incididunt cupidatat dolor est',
                                                         set: 'velit ad ut'
                                                       })
            id = response.data.options.first.modifiers.first.id

            response = option.product_modifiers.delete(id)
            expect(response.response_status).to eq 200
          end
        end
      end
    end
  end
end
