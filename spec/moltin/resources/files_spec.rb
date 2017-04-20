require 'spec_helper'

module Moltin
  module Resources
    describe Files do
      let(:config) { Configuration.new }

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
          file = Moltin::Resources::Files.new(config, {})
          expect(file.send(:uri)).to eq 'v2/files'
        end
      end

      describe '#all' do
        it 'receives the list of files' do
          VCR.use_cassette('resources/files/all') do
            resource = Moltin::Resources::Files.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::File)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 100
          end
        end

        context 'pagination' do
          context 'limit & offset' do
            it 'limits the number of results and set the offset' do
              VCR.use_cassette('resources/files/all/limit-offset') do
                resource = Moltin::Resources::Files.new(config, {})
                response = resource.limit(10).offset(10)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/files?page[offset]=10&page[limit]=10&filter='
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'limit' do
            it 'limits the number of results returned by the API' do
              VCR.use_cassette('resources/files/all/limit') do
                resource = Moltin::Resources::Files.new(config, {})
                response = resource.limit(10)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/files?page[offset]=0&page[limit]=10&filter='
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'offset' do
            it 'offsets the returned results' do
              VCR.use_cassette('resources/files/all/offset') do
                resource = Moltin::Resources::Files.new(config, {})
                response = resource.offset(100)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/files?page[offset]=100&page[limit]=100&filter='
                )
                expect(response.data.length).to eq 100
              end
            end
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/files/attributes') do
            resource = Moltin::Resources::Files.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(
              ['Type', 'Id', 'Link', 'File Name', 'Mime Type', 'File Size', 'Public']
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given file', freeze_time: true do
          VCR.use_cassette('resources/files/get') do
            resource = Moltin::Resources::Files.new(config, {})
            file = resource.all.data.first
            response = resource.get(file.id)

            expect(response.data.id).to eq file.id
            expect(response.data).to be_kind_of(Moltin::Models::File)
          end
        end
      end

      describe '#create' do
        context 'valid file' do
          it 'creates a new file', freeze_time: true do
            VCR.use_cassette('resources/files/create/valid') do
              resource = Moltin::Resources::Files.new(config, {})
              response = resource.create(Moltin.root + '/spec/fixtures/files/desk.jpg')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::File)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'remote file' do
          it 'creates a new file', freeze_time: true do
            VCR.use_cassette('resources/files/create/remote') do
              resource = Moltin::Resources::Files.new(config, {})
              response = resource.create('http://c93fea60bb98e121740fc38ff31162a8.s3.amazonaws.com/wp-content/uploads/2016/01/moltin_logo.png')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data.public).to eq true
              expect(response.data).to be_kind_of(Moltin::Models::File)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'with more attributes' do
          it 'creates a new file as private', freeze_time: true do
            VCR.use_cassette('resources/files/create/private') do
              resource = Moltin::Resources::Files.new(config, {})
              response = resource.create(Moltin.root + '/spec/fixtures/files/desk.jpg', public: false)

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data.public).to eq false
              expect(response.data).to be_kind_of(Moltin::Models::File)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid file' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/files/create/invalid') do
              expect do
                resource = Moltin::Resources::Files.new(config, {})
                resource.create('/this/file/does/not/exist')
              end.to raise_error(Errno::ENOENT)
            end
          end
        end
      end
    end
  end
end
