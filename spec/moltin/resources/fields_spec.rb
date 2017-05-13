require 'spec_helper'

module Moltin
  module Resources
    describe Fields do
      let(:config) { Configuration.new }
      let(:client) { Client.new }
      let(:flow) { client.flows.all.first }

      describe '#uri' do
        it 'returns the expected uri' do
          field = Moltin::Resources::Fields.new(config, {})
          expect(field.send(:uri)).to eq 'v2/fields'
        end
      end

      describe '#all' do
        it 'receives the list of fields', freeze_time: true do
          VCR.use_cassette('resources/fields/all') do
            response = flow.fields.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Field)
            expect(response.response_links).not_to be_nil
            expect(response.included).to be_kind_of Moltin::Models::Included
            expect(response.response_meta).not_to be_nil

            expect(response.data.length).to eq 2
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes', freeze_time: true do
          VCR.use_cassette('resources/fields/attributes') do
            response = client.fields.attributes

            expect(response.data.map(&:label)).to eq(
              ['Id', 'Type', 'Field Type', 'Name', 'Required', 'Unique', 'Default', 'Description']
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given field', freeze_time: true do
          VCR.use_cassette('resources/fields/get') do
            field = flow.fields.all.first
            response = client.fields.get(field.id)

            expect(response.data.id).to eq field.id
            expect(response.data).to be_kind_of(Moltin::Models::Field)
          end
        end
      end

      describe '#create' do
        it 'creates a new field', freeze_time: true do
          VCR.use_cassette('resources/fields/create') do
            response = client.fields.create(field_type: 'string',
                                            slug: 'content',
                                            name: 'content',
                                            description: 'Just an additional reference',
                                            required: false,
                                            unique: true,
                                            default: '',
                                            relationships: {
                                              flow: {
                                                data: {
                                                  type: 'flow',
                                                  id: flow.id
                                                }
                                              }
                                            })

            id = response.data.id
            expect(id).not_to be_nil
            expect(response.data).to be_kind_of(Moltin::Models::Field)

            product = client.products.all.first
            expect(product.flow_fields.content).to eq nil
          end
        end
      end

      describe '#update' do
        it 'updates a new field', freeze_time: true do
          VCR.use_cassette('resources/fields/update') do
            field = flow.fields.all.first
            response = client.fields.update(field.id, description: 'Something else.')

            expect(response.data.description).to eq 'Something else.'
            expect(response.data).to be_kind_of(Moltin::Models::Field)
          end
        end
      end
    end
  end
end
