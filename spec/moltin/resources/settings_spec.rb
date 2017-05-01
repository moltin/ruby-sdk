require 'spec_helper'

module Moltin
  module Resources
    describe Settings do
      let(:config) { Configuration.new }
      let(:client) { Moltin::Client.new }

      describe '#uri' do
        it 'returns the expected uri' do
          setting = Moltin::Resources::Settings.new(config, {})
          expect(setting.send(:uri)).to eq 'v2/settings'
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/settings/attributes') do
            response = client.settings.attributes

            expect(response.data.map(&:label)).to eq(
              ['Type', 'Page Length', 'Return Variations', 'Quantity Greater_stock',
               'Email From_address', 'Email From_name', 'Email Smtp_host',
               'Email Smtp_port', 'Email Smtp_username', 'Email Smtp_password',
               'Email Owner', 'Email Encryption', 'Timezone', 'Password Policy']
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#all' do
        it 'receives the list of settings' do
          VCR.use_cassette('resources/settings/all') do
            response = client.settings.all

            expect(response.data).not_to be_nil
            expect(response.data).to be_kind_of(Moltin::Models::Setting)
          end
        end
      end

      describe '#update' do
        it 'updates the settings', freeze_time: true do
          VCR.use_cassette('resources/settings/update') do
            response = client.settings.update(page_length: 12)
            expect(response.page_length).to eq 12
            response = client.settings.update(page_length: 100)
            expect(response.page_length).to eq 100
          end
        end
      end
    end
  end
end
