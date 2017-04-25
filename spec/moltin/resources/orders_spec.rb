require 'spec_helper'

module Moltin
  module Resources
    describe Orders do
      let(:config) { Configuration.new }
      let(:products) { Moltin::Resources::Products.new(config, {}).all.data }
      let(:product) { products.first }
      let(:client) { Moltin::Client.new }

      def create_order
        client.carts.delete('my_new_order')

        cart = client.carts.get('my_new_order').data
        cart.add(id: product.id).data
        client.carts.checkout(cart.id, customer: {
                                         name: 'Billy',
                                         email: 'billy@billy.com'
                                       },
                                       billing_address: {
                                         first_name: 'Jack',
                                         last_name: 'Macdowall',
                                         company_name: 'Macdowalls',
                                         line_1: '1225 Invention Avenue',
                                         line_2: 'Birmingham',
                                         postcode: 'B21 9AF',
                                         county: 'West Midlands',
                                         country: 'UK'
                                       },
                                       shipping_address: {
                                         first_name: 'Otis',
                                         last_name: 'Sedmak',
                                         company_name: 'Sedmak & Co.',
                                         line_1: '1251, Rexmere Ave',
                                         line_2: 'Farmingville, Suffolk',
                                         postcode: '11738',
                                         county: 'New York',
                                         country: 'US',
                                         instructions: 'Leave in porch'
                                       }).data
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
          order = Moltin::Resources::Orders.new(config, {})
          expect(order.send(:uri)).to eq 'v2/orders'
        end
      end

      describe '#all' do
        it 'receives the list of orders', freeze_time: true do
          VCR.use_cassette('resources/orders/all') do
            create_order
            resource = Moltin::Resources::Orders.new(config, {})
            response = resource.all

            expect(response.data).not_to be_nil
            expect(response.data.first).to be_kind_of(Moltin::Models::Order)
            expect(response.links).not_to be_nil
            expect(response.included).to eq({})
            expect(response.meta).not_to be_nil

            expect(response.data.length).to eq 25
          end
        end
      end

      describe '#get' do
        it 'receives the given order', freeze_time: true do
          VCR.use_cassette('resources/orders/get') do
            create_order
            resource = Moltin::Resources::Orders.new(config, {})
            order = resource.all.data.first
            response = resource.get(order.id)

            expect(response.data.id).to eq order.id
            expect(response.data).to be_kind_of(Moltin::Models::Order)
          end
        end
      end

      describe '#items' do
        it 'receives the items', freeze_time: true do
          VCR.use_cassette('resources/orders/items') do
            create_order
            order = client.orders.all.data.first
            items = order.items.data
            expect(items.length).to eq 1
          end
        end
      end

      describe '#pay' do
        it 'pays for the order', freeze_time: true do
          VCR.use_cassette('resources/orders/pay') do
            client.gateways.update('stripe', {
              enabled: true,
              login: 'sk_test_gRJKVmpX8UGWBpUp25p7Gp7f'
            })
            order = create_order
            #order = client.orders.all.data.last
            payment = order.pay({
              gateway: "stripe",
              method: "purchase",
              first_name: "John",
              last_name: "Doe",
              number: "4242424242424242",
              month: "08",
              year: "2020",
              verification_value: "123"
            })
            order = client.orders.get(order.id)
            expect(order.status).to eq 'complete'
            expect(order.payment).to eq 'paid'
          end
        end
      end

      describe '#transactions' do
        it 'receives the transactions', freeze_time: true # do
        # VCR.use_cassette('resources/orders/transactions') do
        #   create_order
        #   order = client.orders.all.data.first
        #   transactions = order.transactions.data
        # end
        # end
      end
    end
  end
end
