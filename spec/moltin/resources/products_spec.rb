require 'spec_helper'

module Moltin
  module Resources
    describe Products do
      let(:config) { Configuration.new }

      before do
        ENV['MOLTIN_CLIENT_ID'] = ENV['FAKE_CLIENT_ID']
        ENV['MOLTIN_CLIENT_SECRET'] = 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'
      end

      after do
        ENV.delete('MOLTIN_CLIENT_ID')
        ENV.delete('MOLTIN_CLIENT_ID')
      end

      describe '#uri' do
        it 'returns the expected uri' do
          product = Moltin::Resources::Products.new(config, {})
          expect(product.send(:uri)).to eq 'v2/products'
        end
      end

      describe '#all' do
        it 'receives the list of products' do
          VCR.use_cassette('resources/products/all') do
            resource = Moltin::Resources::Products.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Product)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 68
          end
        end

        context 'pagination' do
          context 'limit & offset' do
            it 'limits the number of results and set the offset' do
              VCR.use_cassette('resources/products/all/limit-offset') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.limit(10).offset(10)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=10&page[offset]=10'
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'limit' do
            it 'limits the number of results returned by the API' do
              VCR.use_cassette('resources/products/all/limit') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.limit(10)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=10&page[offset]=0'
                )
                expect(response.data.length).to eq 10
              end
            end
          end

          context 'offset' do
            it 'offsets the returned results' do
              VCR.use_cassette('resources/products/all/offset') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.offset(60)
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=100&page[offset]=60'
                )
                expect(response.data.length).to eq 17
              end
            end
          end
        end

        context 'sorting' do
          context 'ASC' do
            it 'sorts the results based on the passed attribute in ascending sort' do
              VCR.use_cassette('resources/products/all/sort/asc') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.sort('name')
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=100&page[offset]=0&sort=name'
                )
              end
            end
          end

          context 'DESC' do
            it 'sorts the results based on the passed attribute in descending sort' do
              VCR.use_cassette('resources/products/all/sort/desc') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.sort('-name')
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=100&page[offset]=0&sort=-name'
                )
              end
            end
          end
        end

        context 'filter' do
          context 'when filtering with "name has 2017"' do
            it 'filters by name' do
              VCR.use_cassette('resources/products/all/filters/name_has_2017') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.filter(has: { name: '2017' })
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=100&page[offset]=0&filter=has(name,2017)'
                )
                response.data.each do |result|
                  expect(result.name).to include('2017')
                end
              end
            end
          end

          context 'when filtering with "name has 2017" and "stock gt 10"' do
            it 'filters by name, stock and slug' do
              VCR.use_cassette('resources/products/all/filters/composed') do
                resource = Moltin::Resources::Products.new(config, {})
                response = resource.filter(has: { name: '2017' }, out: { slug: %w(abc def) })
                expect(response.links['current']).to eq(
                  'https://api.moltin.com/v2/products?page[limit]=100&page[offset]=0&filter=has(name,2017):out(slug,(abc,def))'
                )
                expect(response.included.keys).not_to eq(%w(brands categories))
              end
            end
          end
        end

        context 'with' do
          it 'includes the specified resources' do
            VCR.use_cassette('resources/products/all/includes') do
              resource = Moltin::Resources::Products.new(config, {})
              response = resource.with(:brands, :categories)
              expect(response.links['current']).to eq(
                'https://api.moltin.com/v2/products?page[limit]=100&page[offset]=0&include=brands,categories'
              )
              expect(response.included.keys).to eq(%w(brands categories))
            end
          end
        end
      end

      describe '#attributes' do
        it 'receives the list of attributes' do
          VCR.use_cassette('resources/products/attributes') do
            resource = Moltin::Resources::Products.new(config, {})
            response = resource.attributes

            expect(response.data.map(&:label)).to eq(
              ['Type', 'Id', 'Name', 'Slug', 'Sku', 'Manage Stock',
               'Description', 'Price', 'Status', 'Commodity Type',
               'Dimensions', 'Weight']
            )
            expect(response.data.first).to be_kind_of(Moltin::Models::Attribute)
          end
        end
      end

      describe '#get' do
        it 'receives the given product', freeze_time: true do
          VCR.use_cassette('resources/products/get') do
            resource = Moltin::Resources::Products.new(config, {})
            product = resource.all.data.first
            response = resource.get(product.id)

            expect(response.data.id).to eq product.id
            expect(response.data).to be_kind_of(Moltin::Models::Product)
          end
        end
      end

      describe '#create' do
        context 'valid product' do
          it 'creates a new product', freeze_time: true do
            VCR.use_cassette('resources/products/create/valid') do
              resource = Moltin::Resources::Products.new(config, {})
              response = resource.create(name: 'My Product',
                                         slug: 'my-product1',
                                         sku: '123',
                                         manage_stock: false,
                                         description: 'Super Product',
                                         status: 'live',
                                         commodity_type: 'digital')

              id = response.data.id
              expect(id).not_to be_nil
              expect(response.data).to be_kind_of(Moltin::Models::Product)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid product' do
          it 'receives the list of errors' do
            VCR.use_cassette('resources/products/create/invalid') do
              resource = Moltin::Resources::Products.new(config, {})
              response = resource.create(slug: 'my-product1',
                                         sku: '123',
                                         manage_stock: false,
                                         description: 'Super Product',
                                         status: 'live',
                                         commodity_type: 'digital')

              expect(response.errors).to eq(
                [{ 'title' => 'Failed Validation', 'detail' => 'The data.name field is required.' }]
              )
            end
          end
        end
      end

      describe '#update' do
        context 'valid product' do
          it 'updates a new product', freeze_time: true do
            VCR.use_cassette('resources/products/update/valid') do
              resource = Moltin::Resources::Products.new(config, {})
              response = resource.create(name: 'My Product',
                                         slug: 'my-product-update-valid',
                                         sku: '123',
                                         manage_stock: false,
                                         description: 'Super Product',
                                         status: 'live',
                                         commodity_type: 'digital')

              id = response.data.id
              response = resource.update(id, name: 'My New Product')

              expect(response.data.name).to eq 'My New Product'
              expect(response.data).to be_kind_of(Moltin::Models::Product)

              response = resource.delete(response.data.id)
              expect(response.data.id).to eq id
            end
          end
        end

        context 'invalid product' do
          it 'receives the list of errors', freeze_time: true do
            VCR.use_cassette('resources/products/update/invalid') do
              resource = Moltin::Resources::Products.new(config, {})
              response = resource.create(name: 'My Product',
                                         slug: 'my-product-update-invalid-1',
                                         sku: '123',
                                         manage_stock: false,
                                         description: 'Super Product',
                                         status: 'live',
                                         commodity_type: 'digital')

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
        it 'deletes the product', freeze_time: true do
          VCR.use_cassette('resources/products/delete') do
            resource = Moltin::Resources::Products.new(config, {})
            response = resource.create(name: 'My Product',
                                       slug: 'my-product-update-valid',
                                       sku: '123',
                                       manage_stock: false,
                                       description: 'Super Product',
                                       status: 'live',
                                       commodity_type: 'digital')

            id = response.data.id
            response = resource.delete(id)
            expect(response.data.id).to eq id

            response = resource.get(id)
            expect(response.errors).to eq([{
                                            'status' => 404,
                                            'detail' => 'The requested product could not be found',
                                            'title' => 'Product not found'
                                          }])
          end
        end
      end

      describe '#create_relationships' do
        context 'relationship not found' do
          it 'raises an error' do

          end
        end

        context 'relationship found' do
          context 'with one id' do
            it 'creates the relationship' do
              VCR.use_cassette('resources/products/relationships/id_string') do
                storage = {}
                products = Moltin::Resources::Products.new(config, storage)
                brands = Moltin::Resources::Brands.new(config, storage)

                product = products.all.data.first
                brand = brands.all.data.first

                response = products.create_relationships(product.id, :brands, brand.id)
              end
            end
          end

          context 'with an array of ids' do

          end
        end
      end
    end
  end
end
