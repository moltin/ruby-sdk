require 'spec_helper'

module Moltin
  module Resources
    describe Entries do
      let(:config) { Configuration.new }
      let(:client) { Client.new }
      let(:flow) { client.flows.all.first }

      describe '#uri' do
        it 'returns the expected uri' do
          entry = Moltin::Resources::Entries.new(config, {}, flow_slug: 'test')
          expect(entry.send(:uri)).to eq 'v2/flows/test/entries'
        end
      end

      describe '#all' do
        it 'receives the list of entries', freeze_time: true do
          VCR.use_cassette('resources/entries/all') do
            response = flow.entries.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Entry)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 2
          end
        end
      end

      describe '#get' do
        it 'receives the given entry', freeze_time: true do
          VCR.use_cassette('resources/entries/get') do
            entry = flow.entries.all.first
            response = flow.entries.get(entry.id)

            expect(response.data.id).to eq entry.id
            expect(response.data).to be_kind_of(Moltin::Models::Entry)
          end
        end
      end

      describe '#create' do
        it 'creates a new entry', freeze_time: true do
          VCR.use_cassette('resources/entries/create') do
            response = flow.entries.create(reference: 'cool value')

            id = response.data.id
            expect(id).not_to be_nil
            expect(response.data).to be_kind_of(Moltin::Models::Entry)
          end
        end
      end

      describe '#update' do
        it 'updates a new entry', freeze_time: true do
          VCR.use_cassette('resources/entries/update') do
            entry = flow.entries.all.first
            response = flow.entries.update(entry.id, reference: 'Something else.')

            expect(response.data.flow_fields.reference).to eq 'Something else.'
            expect(response.data).to be_kind_of(Moltin::Models::Entry)
          end
        end
      end
    end
  end
end
