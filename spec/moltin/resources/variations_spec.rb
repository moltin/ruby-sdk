require 'spec_helper'

module Moltin
  module Resources
    describe Variations do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }

      describe '#uri' do
        it 'returns the expected uri' do
          variation = Moltin::Resources::Variations.new(config, {})
          expect(variation.send(:uri)).to eq 'v2/variations'
        end
      end

      describe '#all' do
        it 'receives the list of variations' do
          VCR.use_cassette('resources/variations/all') do
            resource = Moltin::Resources::Variations.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Variation)
            expect(response.response_links).not_to be_nil
            expect(response.included).to be_kind_of Moltin::Models::Included
            expect(response.response_meta).not_to be_nil

            expect(response.data.length).to eq 2
          end
        end
      end

      describe '#get' do
        it 'receives the given variation', freeze_time: true do
          VCR.use_cassette('resources/variations/get') do
            resource = Moltin::Resources::Variations.new(config, {})
            variation = resource.all.data.first
            response = resource.get(variation.id)

            expect(response.data.id).to eq variation.id
            expect(response.data).to be_kind_of(Moltin::Models::Variation)
          end
        end
      end

      describe '#create' do
        context 'valid variation' do
          it 'creates a new variation', freeze_time: true do
            VCR.use_cassette('resources/variations/create/valid') do
              resource = Moltin::Resources::Variations.new(config, {})
              response = resource.create(name: 'My Variation')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Variation)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid variation' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/variations/create/invalid') do
              resource = Moltin::Resources::Variations.new(config, {})
              response = resource.create(slug: 'my-variation1')

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
            VCR.use_cassette('resources/variations/update/valid') do
              resource = Moltin::Resources::Variations.new(config, {})
              response = resource.create(name: 'My Variation')

              id = response.data.id
              response = resource.update(id, name: 'My New Variation')

              expect(response.data.name).to eq 'My New Variation'
              expect(response.data).to be_kind_of(Moltin::Models::Variation)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end
      end

      describe '#delete' do
        it 'deletes the variation', freeze_time: true do
          VCR.use_cassette('resources/variations/delete') do
            resource = Moltin::Resources::Variations.new(config, {})
            response = resource.create(name: 'My Variation')

            id = response.data.id
            response = resource.delete(id)
            expect(response.data.id).to eq id

            response = resource.get(id)
            expect(response.errors).to eq([{
                                            'status' => 404,
                                            'detail' => 'The requested variation could not be found',
                                            'title' => 'Variation not found'
                                          }])
          end
        end
      end
    end
  end
end
