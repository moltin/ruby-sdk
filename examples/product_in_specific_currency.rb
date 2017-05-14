require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  random_string = SecureRandom.hex

  currencies = moltin.currencies.all.data

  ap '---------------------------'
  ap 'Creating two new currencies...'
  currency_list = []
  currency_data = [
    {
      code: 'ABC',
      exchange_rate: 1,
      default: false,
      enabled: true,
      decimal_point: '.',
      decimal_places: 2,
      thousand_separator: ',',
      format: '$-ABC {price}'
    },
    {
      code: 'DEF',
      exchange_rate: 1,
      default: false,
      enabled: true,
      decimal_point: '.',
      decimal_places: 2,
      thousand_separator: ',',
      format: '$-DEF {price}'
    }
  ]

  currency_data.each do |currency|
    if cur = currencies.detect { |c| c.code == currency[:code] }
      currency_list << cur
    else
      response = moltin.currencies.create(currency)

      if response.response_status != 201
        ap "Couldn't create currency. #{response.errors}"
      else
        currency_list << response.data
      end
    end
  end

  ap '---------------------------'
  ap 'Creating a new product with both currencies...'
  product = moltin.products.create(type: 'product',
                                   name: "My Product Currency #{random_string}",
                                   slug: "my-product-currency-#{random_string}",
                                   sku: "my.prod.#{random_string}",
                                   description: 'a bit about it',
                                   manage_stock: false,
                                   status: 'live',
                                   commodity_type: 'digital',
                                   price: [
                                     {
                                       amount: 5000,
                                       currency: currency_list.first.code,
                                       includes_tax: true
                                     },
                                     {
                                       amount: 3500,
                                       currency: currency_list.last.code,
                                       includes_tax: true
                                     }
                                   ]).data
  ap product

  ap '---------------------------'
  ap 'Request product in ABC currency...'
  productABC = moltin.currency('ABC').products.get(product.id).data
  ap productABC

  ap '---------------------------'
  ap 'Request product in DEF currency...'
  productDEF = moltin.currency('DEF').products.get(product.id).data
  ap productDEF

  ap '---------------------------'
  ap 'Cleaning up...'
  moltin.products.delete(product.id)
  moltin.currencies.delete(currencies.first.id)
  moltin.currencies.delete(currencies.last.id)
rescue => e
  ap 'Something went wrong.'
  ap e
end
