require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  ap '---------------------------'
  ap 'Retrieve all the products...'
  products = moltin.products.all.data
  ap products
rescue => e
  ap 'Something went wrong.'
  ap e
end
