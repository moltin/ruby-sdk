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
            expect(response.included).to be_nil
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 68
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
    end
  end
end
