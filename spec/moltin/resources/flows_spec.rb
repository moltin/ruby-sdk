require 'spec_helper'

module Moltin
  module Resources
    describe Flows do
      let(:config) { Configuration.new }
      let(:client) { Client.new }

      describe '#uri' do
        it 'returns the expected uri' do
          flow = Moltin::Resources::Flows.new(config, {})
          expect(flow.send(:uri)).to eq 'v2/flows'
        end
      end

      describe '#all' do
        it 'receives the list of flows' do
          VCR.use_cassette('resources/flows/all') do
            response = client.flows.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Flow)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 1
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/flows/attributes') do
            response = client.flows.attributes

            expect(response.data.map(&:label)).to eq(
              %w(Id Type Name Slug Description Enabled)
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given flow', freeze_time: true do
          VCR.use_cassette('resources/flows/get') do
            flow = client.flows.all.first
            response = client.flows.get(flow.id)

            expect(response.data.id).to eq flow.id
            expect(response.data).to be_kind_of(Moltin::Models::Flow)
          end
        end
      end

      describe '#create' do
        it 'creates a new flow', freeze_time: true do
          VCR.use_cassette('resources/flows/create') do
            response = client.flows.create(name: 'reference',
                                           slug: 'products',
                                           description: 'Just a nice reference.',
                                           enabled: false)

            id = response.data.id
            expect(id).not_to be_nil
            expect(response.data).to be_kind_of(Moltin::Models::Flow)
          end
        end
      end

      describe '#update' do
        it 'updates a new flow', freeze_time: true do
          VCR.use_cassette('resources/flows/update') do
            flow = client.flows.all.first
            response = client.flows.update(flow.id, enabled: true, description: 'Something else.')
            expect(response.data.description).to eq 'Something else.'
            expect(response.data).to be_kind_of(Moltin::Models::Flow)
          end
        end
      end
    end
  end
end
