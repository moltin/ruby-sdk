require 'spec_helper'

module Moltin
  module Resources
    describe Carts do
      let(:config) { Configuration.new }
      let(:products) { Moltin::Resources::Products.new(config, {}).all.data }
      let(:product) { products.first }
      let(:client) { Moltin::Client.new }

      let(:customer) do
        { name: 'Billy', email: 'billy@billy.com' }
      end

      let(:billing_address) do
        {
          first_name: 'Jack',
          last_name: 'Macdowall',
          company_name: 'Macdowalls',
          line_1: '1225 Invention Avenue',
          line_2: 'Birmingham',
          postcode: 'B21 9AF',
          county: 'West Midlands',
          country: 'UK'
        }
      end

      let(:shipping_address) do
        {
          first_name: 'Otis',
          last_name: 'Sedmak',
          company_name: 'Sedmak & Co.',
          line_1: '1251, Rexmere Ave',
          line_2: 'Farmingville, Suffolk',
          postcode: '11738',
          county: 'New York',
          country: 'US',
          instructions: 'Leave in porch'
        }
      end

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
          cart = Moltin::Resources::Carts.new(config, {})
          expect(cart.send(:uri)).to eq 'v2/carts'
        end
      end

      describe '#get' do
        it 'receives the given cart', freeze_time: true do
          VCR.use_cassette('resources/carts/get') do
            client.carts.delete('my_secret_cart')

            resource = Moltin::Resources::Carts.new(config, {})
            response = resource.get('my_secret_cart')

            expect(response.data.id).to eq 'my_secret_cart'
            expect(response.data).to be_kind_of(Moltin::Models::Cart)
          end
        end
      end

      describe '#delete' do
        it 'deletes the cart', freeze_time: true do
          VCR.use_cassette('resources/carts/delete') do
            client.carts.delete('my_secret_cart')

            resource = Moltin::Resources::Carts.new(config, {})
            resource.get('my_secret_cart')
            response = resource.delete('my_secret_cart')
            expect(response.data[0].id).to eq 'my_secret_cart'
          end
        end
      end

      describe '#items' do
        it 'retrieves the items in the cart', freeze_time: true do
          VCR.use_cassette('resources/carts/items/all') do
            client.carts.delete('my_secret_cart')

            cart = client.carts.get('my_secret_cart')
            cart.add(id: products[0].id).data
            cart.add(id: products[1].id).data
            cart.add(id: products[2].id).data

            expect(cart.items.length).to eq(3)
            expect(client.carts.get('my_secret_cart').items.length).to eq(3)
          end
        end
      end

      describe '#add' do
        context 'cart_item' do
          it 'adds the item in the cart', freeze_time: true do
            VCR.use_cassette('resources/carts/items/add_cart_item') do
              client.carts.delete('my_secret_cart')

              items = client.carts.get('my_secret_cart').add(id: product.id).data
              expect(items.length).to eq 1
            end
          end
        end

        context 'custom_item' do
          it 'adds the item in the cart', freeze_time: true do
            VCR.use_cassette('resources/carts/items/add_custom_item') do
              client.carts.delete('my_secret_cart')

              cart = client.carts.get('my_secret_cart')

              items = cart.add(name: 'Tax',
                               sku: 'tax-calc',
                               description: 'Custom tax calculation for this order',
                               quantity: 1,
                               price: {
                                 amount: 2000
                               }).data

              expect(items.length).to eq 1
            end
          end
        end

        context 'cart_item and custom_item' do
          it 'instantiates the appropriate models', freeze_time: true do
            VCR.use_cassette('resources/carts/items/add_cart_item_and_custom') do
              client.carts.delete('my_secret_cart')

              cart = client.carts.get('my_secret_cart')
              cart.add(id: product.id).data
              cart.add(name: 'Tax',
                       sku: 'tax-calc',
                       description: 'Custom tax calculation for this order',
                       quantity: 1,
                       price: {
                         amount: 2000
                       }).data

              items = client.carts.get('my_secret_cart').items.data
              expect(items.length).to eq 2
              expect(items[0]).to be_kind_of Moltin::Models::CartItem
              expect(items[1]).to be_kind_of Moltin::Models::CartItem
            end
          end
        end
      end

      describe '#update' do
        context 'cart_item' do
          it 'adds the item in the cart', freeze_time: true do
            VCR.use_cassette('resources/carts/items/update_cart_item') do
              client.carts.delete('my_secret_cart')
              cart = client.carts.get('my_secret_cart')

              items = cart.add(id: product.id, quantity: 3).data
              items = cart.update(items.first.id, id: items.first.id, quantity: 5).data
              expect(items.length).to eq 1
              expect(items[0].quantity).to eq 5
            end
          end
        end
      end

      describe '#remove' do
        it 'removes the item from the cart', freeze_time: true do
          VCR.use_cassette('resources/carts/items/remove') do
            client.carts.delete('my_secret_cart')

            cart = client.carts.get('my_secret_cart')
            items = cart.add(id: product.id).data
            expect(items.length).to eq 1

            items = cart.remove(items.first.id).data
            expect(items.length).to eq 0
          end
        end
      end

      describe '#checkout' do
        it 'checks out the cart and generate an order', freeze_time: true do
          VCR.use_cassette('resources/carts/checkout') do
            client.carts.delete('my_secret_cart')

            cart = client.carts.get('my_secret_cart').data
            cart.add(id: product.id).data

            order = client.carts.checkout(cart.id, customer: customer,
                                                   billing_address: billing_address,
                                                   shipping_address: shipping_address).data
            expect(order).to be_kind_of Moltin::Models::Order
            expect(order.type).to eq 'order'
          end
        end
      end
    end
  end
end
