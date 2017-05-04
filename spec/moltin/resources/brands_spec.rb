require 'spec_helper'

module Moltin
  module Resources
    describe Brands do
      let(:config) { Configuration.new }

      describe '#uri' do
        it 'returns the expected uri' do
          brand = Moltin::Resources::Brands.new(config, {})
          expect(brand.send(:uri)).to eq 'v2/brands'
        end
      end

      describe '#all' do
        it 'receives the list of brands' do
          VCR.use_cassette('resources/brands/all') do
            resource = Moltin::Resources::Brands.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Brand)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 49
          end
        end

        context 'pagination' do
          context 'limit & offset' do
            it 'limits the number of results and set the offset' do
              VCR.use_cassette('resources/brands/all/limit-offset') do
                resource = Moltin::Resources::Brands.new(config, {})
                response = resource.limit(10).offset(10)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/brands?page[limit]=10&page[offset]=10'
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'limit' do
            it 'limits the number of results returned by the API' do
              VCR.use_cassette('resources/brands/all/limit') do
                resource = Moltin::Resources::Brands.new(config, {})
                response = resource.limit(10)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/brands?page[limit]=10&page[offset]=0'
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'offset' do
            it 'offsets the returned results' do
              VCR.use_cassette('resources/brands/all/offset') do
                resource = Moltin::Resources::Brands.new(config, {})
                response = resource.offset(20)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/brands?page[limit]=100&page[offset]=20'
                )
                expect(response.data.length).to eq 29
              end
            end
          end
        end

        context 'sorting' do
          context 'ASC' do
            it 'sorts the results based on the passed attribute in ascending sort' do
              VCR.use_cassette('resources/brands/all/sort/asc') do
                resource = Moltin::Resources::Brands.new(config, {})
                response = resource.sort('name')
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/brands?page[limit]=100&page[offset]=0&sort=name'
                )
              end
            end
          end

          context 'DESC' do
            it 'sorts the results based on the passed attribute in descending sort' do
              VCR.use_cassette('resources/brands/all/sort/desc') do
                resource = Moltin::Resources::Brands.new(config, {})
                response = resource.sort('-name')
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/brands?page[limit]=100&page[offset]=0&sort=-name'
                )
              end
            end
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/brands/attributes') do
            resource = Moltin::Resources::Brands.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(
              %w(Type Id Name Slug Status Description)
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given brand', freeze_time: true do
          VCR.use_cassette('resources/brands/get') do
            resource = Moltin::Resources::Brands.new(config, {})
            brand = resource.all.data.first
            response = resource.get(brand.id)

            expect(response.data.id).to eq brand.id
            expect(response.data).to be_kind_of(Moltin::Models::Brand)
          end
        end
      end

      describe '#create' do
        context 'valid brand' do
          it 'creates a new brand', freeze_time: true do
            VCR.use_cassette('resources/brands/create/valid') do
              resource = Moltin::Resources::Brands.new(config, {})
              response = resource.create(name: 'My Brand',
                                         slug: 'my-brand1',
                                         description: 'Super Brand',
                                         status: 'live')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Brand)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid brand' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/brands/create/invalid') do
              resource = Moltin::Resources::Brands.new(config, {})
              response = resource.create(slug: 'my-brand1',
                                         description: 'Super Brand',
                                         status: 'live')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid brand' do
          it 'updates a new brand', freeze_time: true do
            VCR.use_cassette('resources/brands/update/valid') do
              resource = Moltin::Resources::Brands.new(config, {})
              response = resource.create(name: 'My Brand',
                                         slug: 'my-brand-update-valid',
                                         description: 'Super Brand',
                                         status: 'live')

              id = response.data.id
              response = resource.update(id, name: 'My New Brand')

              expect(response.data.name).to eq 'My New Brand'
              expect(response.data).to be_kind_of(Moltin::Models::Brand)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid brand' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/brands/update/invalid') do
              resource = Moltin::Resources::Brands.new(config, {})
              response = resource.create(name: 'My Brand',
                                         slug: 'my-brand-update-invalid-1',
                                         description: 'Super Brand',
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
        it 'deletes the brand', freeze_time: true do
          VCR.use_cassette('resources/brands/delete') do
            resource = Moltin::Resources::Brands.new(config, {})
            response = resource.create(name: 'My Brand',
                                       slug: 'my-brand-update-valid',
                                       description: 'Super Brand',
                                       status: 'live')

            id = response.data.id
            response = resource.delete(id)
            expect(response.data.id).to eq id

            response = resource.get(id)
            expect(response.errors).to eq([{
                                            'status' => 404,
                                            'detail' => 'The requested brand could not be found',
                                            'title' => 'Brand not found'
                                          }])
          end
        end
      end
    end
  end
end
