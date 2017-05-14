require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  cart_id = SecureRandom.hex

  # Getting the cart
  ap '---------------------------'
  ap 'Getting cart...'
  cart = moltin.carts.get(cart_id)

  # Adding a product
  ap '---------------------------'
  ap 'Retrieving first product...'
  product = moltin.products.all.first
  ap "Adding product #{product.id} to cart..."
  reponse = cart.add(id: product.id, quantity: 2)
  ap 'Product added.'
  ap reponse

  # Getting all the cart items
  ap '---------------------------'
  ap 'Retrieving cart items...'
  items = cart.items.data
  ap items

  # Updating a product
  ap '---------------------------'
  ap 'Updating quantity to 3'
  response = cart.update(items.first.id, quantity: 3)
  ap response

  # Removing a product
  ap '---------------------------'
  ap "Removing product with cart item id #{items.first.id}"
  response = cart.remove(items.first.id)
  ap response

  # Checkout the cart
  ap '---------------------------'
  ap 'Adding back the product and checking out the cart...'
  cart.add(id: product.id, quantity: 1)

  address = {
    first_name: 'Jack',
    last_name: 'Macdowall',
    company_name: 'Macdowalls',
    line_1: '1225 Invention Avenue',
    line_2: 'Birmingham',
    postcode: 'B21 9AF',
    county: 'West Midlands',
    country: 'UK'
  }
  response = cart.checkout(customer: {
                             name: 'John',
                             email: 'john@doe.com'
                           },
                           billing_address: address,
                           shipping_address: address)
  order = response.data
  ap response

  ap '---------------------------'
  ap 'Paying for the order...'
  response = order.pay(gateway: 'stripe',
                       method: 'purchase',
                       first_name: 'John',
                       last_name: 'Doe',
                       number: '4242424242424242',
                       month: 0o1,
                       year: 22,
                       verification_value: 123)
  ap response

  ap '---------------------------'
  ap 'Getting all the order infos...'
  order = moltin.orders.get(order.id).data
  ap order
rescue => e
  ap 'Something went wrong.'
  ap e
end
