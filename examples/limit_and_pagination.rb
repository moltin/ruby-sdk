require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  ap '---------------------------'
  ap 'Limit to 10...'
  products = moltin.products.all.limit(10).data
  ap products

  ap '---------------------------'
  ap 'Limit to 10 and offset of 10...'
  products = moltin.products.all.limit(10).offset(10).data
  ap products

  ap '---------------------------'
  ap 'Sorting by name...'
  products = moltin.products.all.limit(10).sort('name').data
  ap products

  ap '---------------------------'
  ap 'Reverse sorting by name...'
  products = moltin.products.all.limit(10).sort('-name').data
  ap products

rescue => e
  ap 'Something went wrong.'
  ap e
end
