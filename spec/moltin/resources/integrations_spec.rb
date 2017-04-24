require 'spec_helper'

module Moltin
  module Resources
    describe Integrations do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }

      before do
        ENV['MOLTIN_CLIENT_ID'] = ENV['FAKE_CLIENT_ID']
        ENV['MOLTIN_CLIENT_SECRET'] = ENV['FAKE_CLIENT_SECRET']
      end

      after do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_SECRET')
      end

      describe '#uri' do
        it 'returns the expected uri' do
          integration = Moltin::Resources::Integrations.new(config, {})
          expect(integration.send(:uri)).to eq 'v2/integrations'
        end
      end

      describe '#all' do
        it 'receives the list of integrations' do
          VCR.use_cassette('resources/integrations/all') do
            resource = Moltin::Resources::Integrations.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Integration)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 1
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/integrations/attributes') do
            resource = Moltin::Resources::Integrations.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(['Type', 'Id', 'Integration Type',
                                                      'Enabled', 'Name', 'Description', 'Observes', 'Configuration'])
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given integration', freeze_time: true do
          VCR.use_cassette('resources/integrations/get') do
            resource = Moltin::Resources::Integrations.new(config, {})
            integration = resource.all.data.first
            response = resource.get(integration.id)

            expect(response.data.id).to eq integration.id
            expect(response.data).to be_kind_of(Moltin::Models::Integration)
          end
        end
      end

      describe '#create' do
        context 'valid integration' do
          it 'creates a new integration', freeze_time: true do
            VCR.use_cassette('resources/integrations/create/valid') do
              resource = Moltin::Resources::Integrations.new(config, {})
              response = resource.create(name: 'My Integration',
                                         enabled: true,
                                         integration_type: 'webhook',
                                         observes: ['file.created'],
                                         configuration: {
                                           url: 'http://example.com'
                                         })

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Integration)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid integration' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/integrations/create/invalid') do
              resource = Moltin::Resources::Integrations.new(config, {})
              response = resource.create(name: 'My Integration',
                                         enabled: true,
                                         integration_type: 'webhook',
                                         configuration: {
                                           url: 'http://example.com'
                                         })

              expect(response.errors).to eq(
                [{ 'title' => 'Missing required property: observes' }]
              )
            end
          end
        end
      end

      # describe '#update' do
      #   context 'valid integration' do
      #     it 'updates a new integration', freeze_time: true do
      #       VCR.use_cassette('resources/integrations/update/valid') do
      #         resource = Moltin::Resources::Integrations.new(config, {})
      #         response = resource.create(name: 'My Integration',
      #                                    enabled: true,
      #                                    integration_type: 'webhook',
      #                                    observes: ['file.created'],
      #                                    configuration: {
      #                                      url: 'http://example.com'
      #                                   })
      #
      #         id = response.data.id
      #         response = resource.update(id, name: 'My New Integration',
      #                                        integration_type: 'webhook')
      #
      #         expect(response.data.name).to eq 'My New Integration'
      #         expect(response.data).to be_kind_of(Moltin::Models::Integration)
      #
      #         response = resource.delete(response.data.id)
      #         expect(response.data.id).to eq id
      #       end
      #     end
      #   end
      #
      #   context 'invalid integration' do
      #     it 'receives the list of errors', freeze_time: true do
      #       VCR.use_cassette('resources/integrations/update/invalid') do
      #         resource = Moltin::Resources::Integrations.new(config, {})
      #         response = resource.create(name: 'My Integration',
      #                                    enabled: true,
      #                                    integration_type: 'webhook',
      #                                    observes: ['file.created'],
      #                                    configuration: {
      #                                      url: 'http://example.com'
      #                                   })
      #         p response
      #         id = response.data.id
      #         response = resource.update(id, observes: nil)
      #
      #         expect(response.errors).to eq(
      #           [{"title":"Missing required property: observes"}]
      #         )
      #
      #         response = resource.delete(id)
      #         expect(response.data.id).to eq id
      #       end
      #     end
      #   end
      # end

      describe '#delete' do
        it 'deletes the integration', freeze_time: true do
          VCR.use_cassette('resources/integrations/delete') do
            resource = Moltin::Resources::Integrations.new(config, {})
            response = resource.create(name: 'My Integration',
                                       enabled: true,
                                       integration_type: 'webhook',
                                       observes: ['file.created'],
                                       configuration: {
                                         url: 'http://example.com'
                                       })

            id = response.data.id
            response = resource.delete(id)
            expect(response.data.id).to eq id

            response = resource.get(id)
            expect(response.errors).to eq([{ 'title' => 'Integration not found' }])
          end
        end
      end

      describe '#logs' do
        it 'receives the list of logs' do
          VCR.use_cassette('resources/integrations/logs') do
            resource = Moltin::Resources::Integrations.new(config, {})
            response = resource.logs
            expect(response.status).to eq 200
          end
        end
      end

      describe '#logs_for' do
        it 'receives the list of logs_for' do
          VCR.use_cassette('resources/integrations/logs_for') do
            integration = client.integrations.all.first
            response = integration.logs
            expect(response.status).to eq 200
          end
        end
      end

      describe '#jobs_for' do
        it 'receives the list of jobs' do
          VCR.use_cassette('resources/integrations/jobs') do
            integration = client.integrations.all.first
            response = integration.jobs
            expect(response.status).to eq 200
          end
        end
      end
    end
  end
end
