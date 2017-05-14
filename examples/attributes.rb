require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  response = moltin.products.attributes
  attributes = response.data
  ap attributes
rescue => e
  ap 'Something went wrong.'
  ap e
end
