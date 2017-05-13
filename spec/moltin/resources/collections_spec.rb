require 'spec_helper'

module Moltin
  module Resources
    describe Collections do
      let(:config) { Configuration.new }

      describe '#uri' do
        it 'returns the expected uri' do
          collection = Moltin::Resources::Collections.new(config, {})
          expect(collection.send(:uri)).to eq 'v2/collections'
        end
      end

      describe '#all' do
        it 'receives the list of collections' do
          VCR.use_cassette('resources/collections/all') do
            resource = Moltin::Resources::Collections.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Collection)
            expect(response.response_links).not_to be_nil
            expect(response.included).to be_kind_of Moltin::Models::Included
            expect(response.response_meta).not_to be_nil

            expect(response.data.length).to eq 4
          end
        end

        context 'pagination' do
          context 'limit & offset' do
            it 'limits the number of results and set the offset' do
              VCR.use_cassette('resources/collections/all/limit-offset') do
                resource = Moltin::Resources::Collections.new(config, {})
                response = resource.all.limit(2).offset(2)
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/collections?page[limit]=2&page[offset]=2'
                )
                expect(response.data.length).to eq 2
              end
            end
          end

          context 'limit' do
            it 'limits the number of results returned by the API' do
              VCR.use_cassette('resources/collections/all/limit') do
                resource = Moltin::Resources::Collections.new(config, {})
                response = resource.all.limit(3)
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/collections?page[limit]=3&page[offset]=0'
                )
                expect(response.data.length).to eq 3
              end
            end
          end

          context 'offset' do
            it 'offsets the returned results' do
              VCR.use_cassette('resources/collections/all/offset') do
                resource = Moltin::Resources::Collections.new(config, {})
                response = resource.all.offset(3)
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/collections?page[limit]=100&page[offset]=3'
                )
                expect(response.data.length).to eq 1
              end
            end
          end
        end

        context 'sorting' do
          context 'ASC' do
            it 'sorts the results based on the passed attribute in ascending sort' do
              VCR.use_cassette('resources/collections/all/sort/asc') do
                resource = Moltin::Resources::Collections.new(config, {})
                response = resource.all.sort('name')
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/collections?page[limit]=100&page[offset]=0&sort=name'
                )
              end
            end
          end

          context 'DESC' do
            it 'sorts the results based on the passed attribute in descending sort' do
              VCR.use_cassette('resources/collections/all/sort/desc') do
                resource = Moltin::Resources::Collections.new(config, {})
                response = resource.all.sort('-name')
                expect(response.response_links['current']).to eq(
                  'https://api.moltin.com/v2/collections?page[limit]=100&page[offset]=0&sort=-name'
                )
              end
            end
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/collections/attributes') do
            resource = Moltin::Resources::Collections.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(
              %w(Type Id Name Slug Status Description)
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given collection', freeze_time: true do
          VCR.use_cassette('resources/collections/get') do
            resource = Moltin::Resources::Collections.new(config, {})
            collection = resource.all.data.first
            response = resource.get(collection.id)

            expect(response.data.id).to eq collection.id
            expect(response.data).to be_kind_of(Moltin::Models::Collection)
          end
        end
      end

      describe '#create' do
        context 'valid collection' do
          it 'creates a new collection', freeze_time: true do
            VCR.use_cassette('resources/collections/create/valid') do
              resource = Moltin::Resources::Collections.new(config, {})
              response = resource.create(name: 'My Collection',
                                         slug: 'my-collection1',
                                         description: 'Super Collection',
                                         status: 'live')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Collection)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid collection' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/collections/create/invalid') do
              resource = Moltin::Resources::Collections.new(config, {})
              response = resource.create(slug: 'my-collection1',
                                         description: 'Super Collection',
                                         status: 'live')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid collection' do
          it 'updates a new collection', freeze_time: true do
            VCR.use_cassette('resources/collections/update/valid') do
              resource = Moltin::Resources::Collections.new(config, {})
              response = resource.create(name: 'My Collection',
                                         slug: 'my-collection-update-valid',
                                         description: 'Super Collection',
                                         status: 'live')

              id = response.data.id
              response = resource.update(id, name: 'My New Collection')

              expect(response.data.name).to eq 'My New Collection'
              expect(response.data).to be_kind_of(Moltin::Models::Collection)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid collection' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/collections/update/invalid') do
              resource = Moltin::Resources::Collections.new(config, {})
              response = resource.create(name: 'My Collection',
                                         slug: 'my-collection-update-invalid-1',
                                         description: 'Super Collection',
                                         status: 'live')

              id = response.data.id
              response = resource.update(id, name: '')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )

              response = resource.delete(id)
              expect(response.data.id).to eq id
            end
          end
        end
      end

      describe '#delete' do
        it 'deletes the collection', freeze_time: true do
          VCR.use_cassette('resources/collections/delete') do
            resource = Moltin::Resources::Collections.new(config, {})
            response = resource.create(name: 'My Collection',
                                       slug: 'my-collection-update-valid',
                                       description: 'Super Collection',
                                       status: 'live')

            id = response.data.id
            response = resource.delete(id)
            expect(response.data.id).to eq id

            response = resource.get(id)
            expect(response.errors).to eq([{
                                            'status' => 404,
                                            'detail' => 'The requested product collection could not be found',
                                            'title' => 'Product Collection not found'
                                          }])
          end
        end
      end
    end
  end
end
