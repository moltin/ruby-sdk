require_relative 'init'

# To show the request logs, simply replace the client instantiation
# with moltin = Moltin::Client.new(logger: Logger.new(STDOUT))
moltin = Moltin::Client.new

begin
  random_string = SecureRandom.hex

  ap '---------------------------'
  ap 'Create a new product...'
  product = moltin.products.create(type: 'product',
                                   name: "My Product #{random_string}",
                                   slug: "my-product-#{random_string}",
                                   sku: "my.prod.#{random_string}",
                                   description: 'a bit about it',
                                   manage_stock: false,
                                   status: 'live',
                                   commodity_type: 'digital',
                                   price: [
                                     {
                                       amount: 3500,
                                       currency: 'USD',
                                       includes_tax: true
                                     }
                                   ]).data
  ap product

  ap '---------------------------'
  ap 'Creating a new category...'
  cat1 = moltin.categories.create(name: 'My First Category',
                                  slug: "my-first-category-#{random_string}").data
  ap cat1

  ap '---------------------------'
  ap 'Creating a second category...'
  cat2 = moltin.categories.create(name: 'My Second Category',
                                  slug: "my-second-category-#{random_string}").data
  ap cat2

  ap '---------------------------'
  ap 'Creating a relationship between the first category and the product...'
  response = moltin.products.create_relationships(product.id, 'categories', cat1.id)
  ap response

  ap '---------------------------'
  ap 'Creating a relationship between the second category and the product...'
  response = moltin.products.create_relationships(product.id, 'categories', cat2.id)
  ap response

  ap '---------------------------'
  ap 'Delete the relationship between the product and the first category (inferred using UPDATE)...'
  response = moltin.products.update_relationships(product.id, 'categories', [cat2.id])
  ap response

  ap '---------------------------'
  ap 'Retrieve a product with the category included...'
  product = moltin.products.get(product.id).with(:categories).data
  ap product

  ap 'Delete the relationship between the product and the second category (using DELETE)...'
  response = moltin.products.delete_relationships(product.id, :categories, cat2.id)
  ap response

  ap '---------------------------'
  ap 'Cleaning up...'
  moltin.products.delete(product.id)
  moltin.categories.all.each do |category|
    moltin.categories.delete(category.id)
  end
rescue => e
  ap 'Something went wrong.'
  ap e
  moltin.categories.all.each do |category|
    moltin.categories.delete(category.id)
  end
end
