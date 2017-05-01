# Moltin

[The smarter way to build eCommerce applications](https://www.moltin.com/)

Unified APIs for inventory, carts, the checkout process, payments and more, so you can focus on creating seamless customer experiences at any scale.

This Ruby SDK provides simple access to all the features offered by Moltin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moltin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moltin

## Configuration

In order to use this gem, you need to define your Moltin credentials. This can either be done globally or on a per client basis.

__Note: if you are unsure what your client_id or client_secret are, please select the [store in your account](https://accounts.moltin.com/) and copy them.__

### Global Configuration

By default, the gem will set your credentials using the environment variables below, if they are available.

- `ENV['MOLTIN_CLIENT_ID']`
- `ENV['MOLTIN_CLIENT_SECRET']`

You can also set them yourself when your application is initialized (this can easily fit into an initializer if you are using Ruby on Rails).

```
Moltin.configure do |config|
  config.client_id = 'YOUR_CLIENT_ID'
  config.client_secret = 'YOUR_CLIENT_SECRET'
end
```

### Per Client Configuration

If you need to connect to multiple stores or would prefer to define the configuration for each client instead of globally, you can do it with the following code:

```
Moltin::Client.new({
  client_id: 'YOUR_CLIENT_ID',
  client_secret: 'YOUR_CLIENT_SECRET'
})
```

### Enterprise Customers

If you are an enterprise customer and have your own infrastructure with your own domain, you can configure the client to use your domain by setting the `base_url` option:

```
Moltin.configure do |config|
  config.client_id = 'YOUR_CLIENT_ID'
  config.client_secret = 'YOUR_CLIENT_SECRET'
  config.base_url  = 'https://api.yourdomain.com'
end
```

```
Moltin::Client.new({
  client_id: 'YOUR_CLIENT_ID',
  client_secret: 'YOUR_CLIENT_SECRET',
  base_url:  'https://api.yourdomain.com'
})
```

### Language

Coming Soon.

### Currency

Coming Soon.

## Usage

The client used in the following code examples has been created like this:

```
moltin = Moltin::Client.new({
  client_id: 'YOUR_CLIENT_ID',
  client_secret: 'YOUR_CLIENT_SECRET'
})
```

### Retrieve a list of resources: Products, Brands, Categories, Collections, Files (GET)

The options presented in this section are available for `products`, `brands`, `categories`, `collections` and `files`. Check the [API docs](https://moltin.api-docs.io/v2/using-the-api) for the up-to-date options available for each type of resource.

```
moltin.products.all
# => [Moltin::Models::Product, Moltin::Models::Product]
```

#### Customizing the requests

The requests to retrieve data from the API can be configured for pagination, sorting, filtering and including related resources.

##### Lazy Loading

To allow method chaining, the results are lazy-loaded. Therefore, the request won't happen until you call one of the method triggering the execution like:

 - `errors`
 - `data`
 - `links`
 - `included`
 - `meta`

As in:

```
response = moltin.products.limit(10).offset(10) # or simply moltin.products.all

response.links
response.data
```

If you wish to force the retrieval of resources without using these methods and access the `Moltin::Utils::Response` instance, call `.response`.

```
moltin.products.all.response
```

##### Pagination (Limiting and Offsetting Results)

Limit the number of resources returned:

```
moltin.products.limit(10)
```

Offset the results (page 2):

```
moltin.products.offset(10)
```

##### Sorting

Order by `name`:

```
moltin.products.sort('name')
```

Reversed:

```
moltin.products.sort('-name')
```

##### Filtering

Results can be filtered according to the [specifications from the docs](https://moltin.api-docs.io/v2/using-the-api/filtering).

__Note that not all resources can be filtered. Refer to the docs for the up-to-date list of supported resources (e.g. `/v2/products`).__

A simple filter to get all products currently in stock will look like this:

```
moltin.products.filter({
  gt: { stock: 0 }
})
```

A more advanced filter to find products which are `digital`, `drafted` and have a `stock` greater than `20` will look like this:

```
moltin.products.filter({
  eq: { status: 'draft' },
  eq: { commodity_type: 'digital' },
  gt: { stock: 20 }
})
```

or

```
moltin.products.filter(eq: { status: 'draft' }).
                filter(eq: { commodity_type: 'digital' }).
                filter(gt: { stock: 20 })
```

The hash passed to the `#filter` method should contain all of the conditions required to be met by the API. Multiple filters of the same type can be used (as demonstrated above with `eq`).

[The complete list of predicates is available in the API documentation](https://moltin.api-docs.io/v2/using-the-api/filtering).

##### Including data

To include other data in your request (such as `brands` when getting `products`) call the `with` method on the resource:

```
moltin.products.with(:brands)
```

##### Chaining Methods

All the methods presented above can be chained:

```
moltin.limit(10).offset(10).sort('name').with(:brands).filter(eq: { status: 'draft' })
```

#### Specific cases

##### Fetching the categories tree

```
moltin.categories.tree
```

### Other interactions with resources

##### Products

```
# Retrieve the list of products
moltin.products.all
```

```
# Retrieve a single product (GET)
moltin.products.get(product_id)
```

```
# Create a product (POST)
moltin.products.create({
  name: 'My Product',
  slug: 'my-product',
  sku: '123',
  manage_stock: false,
  description: 'Super Product',
  status: 'live',
  commodity_type: 'digital'
})
```

```
# Update a product (PUT)
moltin.products.update(product_id, {
  name: 'My Product',
  slug: 'my-product',
  sku: '123',
  manage_stock: false,
  description: 'Super Product',
  status: 'live',
  commodity_type: 'digital'
})
```

```
# delete a product (DELETE)
moltin.products.delete(product_id)
```

```
# Build a product variations (POST)
moltin.products.build(product_id)

# Or if you have a Moltin::Models::Product instance
product.build
```

##### Product Variations, Options and Modifiers

```
# Retrieve the list of variations
moltin.variations.all
```

```
# Retrieve a single variation (GET)
moltin.variations.get(variations_id)
```

```
# Create a variation (POST)
moltin.variations.create({
  name: 'inc'
})
```

```
# Update a variation (PUT)
moltin.variations.update(variation_id, {
  name: 'officia fugiat non ad elit'
})
```

```
# delete a variation (DELETE)
moltin.variations.delete(variation_id)
```

##### Product Variation Options

```
# First, retrieve a variation
variation = moltin.variations.all.first

# Or build one
variation = Moltin::Models::Variation.new({ id: variation_id }, moltin)
```

```
# Get the options of a variation
variation.options
```

```
# Create a Product Variation Option (POST)
variation.variation_options.create({
  name: 'irure est',
  description: 'ut nulla ame'  
})
```

```
# Update a Product Variation Option (PUT)
variation.variation_options.update(option_id, {
  description: 'ut nulla ame!'  
})
```

```
# delete a Product Variation Option (DELETE)
variation.variation_options.delete(option_id)
```

##### Product Modifiers

```
# First, retrieve a variation option
option = moltin.variations.all.first.options.first

# Or build one
option = Moltin::Models::VariationOption.new({
  variation_id: variation_id,
  id: option_id
}, moltin)
```

```
# Get the modifiers of a variation option
option.modifiers
```

```
# Create a Product Variation Option Modifier (POST)
option.product_modifiers.create({
  modifier_type: 'sku_builder',
  value: {
    seek: 'in incididunt cupidatat dolor est',
    set: 'velit ad ut'
  }
})
```

```
# Update a Product Variation Option Modifier (PUT)
option.product_modifiers.update(modifier_id, {
  value: {
    seek: 'in incididunt cupidatat dolor est!',
    set: 'velit ad ut!'
  }
})
```

```
# delete a Product Variation Option Modifier (DELETE)
option.product_modifiers.delete(modifier_id)
```

##### Brands

```
# Retrieve the list of brands
moltin.brands.all
```

```
# Retrieve a single brand (GET)
moltin.brands.get(brand_id)
```

```
# Create a brand (POST)
moltin.brands.create({
  name: 'My Brand',
  slug: 'my-brand1',
  description: 'Super Brand',
  status: 'live'
})
```

```
# Update a brand (PUT)
moltin.brands.update(brand_id, {
  slug: 'my-brand1',
  description: 'Super Brand',
  status: 'live'
})
```

```
# delete a brand (DELETE)
moltin.brands.delete(brand_id)
```

##### Categories

```
# Retrieve the list of categories
moltin.categories.all
```

```
# Retrieve a single category (GET)
moltin.categories.get(category_id)
```

```
# Create a category (POST)
moltin.categories.create({
  name: 'My Category',
  slug: 'my-category1',
  description: 'Super Category',
  status: 'live'
})
```

```
# Update a category (POST)
moltin.categories.update(category_id, {
  slug: 'my-category1',
  description: 'Super Category',
  status: 'live'
})
```

```
# delete a category (POST)
moltin.categories.delete(category_id)
```

```
# Get the tree of categories
moltin.categories.tree
```

##### Collections

```
# Retrieve the list of collections
moltin.collections.all
```

```
# Retrieve a single collection (GET)
moltin.collections.get(collection_id)
```

```
# Create a collection (POST)
moltin.collections.create({
  name: 'My Collection',
  slug: 'my-collection',
  description: 'Super Collection',
  status: 'live'
})
```

```
# Update a collection (POST)
moltin.collections.update(collection_id, {
  slug: 'my-collection',
  description: 'Super Collection',
  status: 'live'
})
```

```
# delete a collection (POST)
moltin.collections.delete(collection_id)
```

##### Files

```
# Retrieve the list of files
moltin.files.all
```

```
# Retrieve a single file (GET)
moltin.files.get(file_id)
```

```
# Create a file with local file (POST)
moltin.files.create('/path/to/file', {
  public: true
})
```

```
# Create a file with remote file (POST)
# This will first download the file before
# sending it to the Moltin API
moltin.files.create('https://example.com/myfile', {
  public: true
})
```

```
# delete a file (POST)
moltin.files.delete(file_id)
```

##### Gateways

Payment gateways can be managed through the SDK.

```
# Get all supported gateways
moltin.gateways.all
```

```
# Update a gateway
moltin.gateways.update('stripe', {
  enabled: 'true',
  login: 'stripe_login'
})
```

```
# Shortcut to enable or disable a gateway
moltin.gateways.enable('stripe')
moltin.gateways.disable('stripe')
```

##### Integrations

```
# Get all integrations
moltin.integrations.all
```

```
# Get the integration attributes
moltin.integrations.attributes
```

```
# Get a specific integration
moltin.integrations.get(integration_id)
```

```
# Create an integration
moltin.integrations.create({
  name: 'My Integration',
  enabled: true,
  integration_type: 'webhook',
  observes: ['file.created'],
  configuration: {
    url: 'http://example.com'
  }
})
```

```
# Update an integration
moltin.integrations.update(integration_id, {
  name: 'My New Integration Name',
})
```

```
# Delete an integration
moltin.integrations.delete(integration_id)
```

#### Relationships

Relationships can be created between different entities as shown in the examples below. The last argument (the ids of the related entities) can be passed either as a single string or as an array of strings.

See the [docs](https://moltin.api-docs.io/v2) to learn more about which resources have relationships.

##### Create Relationships

```
# Create relationships between resources:
moltin.products.create_relationships(product_id, 'brands', brand_id);

# Or
moltin.products.create_relationships(product_id, 'brands', [brand_id]);
```

##### Update Relationships

```
# Update the relationships (overrides all the current relationships)
moltin.products.update_relationships(product_id, 'brands', [brand_1_id, brand_2_id]);
```

##### Delete Relationships

```
# Delete a relationship between resources:
moltin.products.delete_relationships(product_id, 'brands', [brand_id]);

# (Or an update with an empty array achieves the same result if you're so inclined):
moltin.products.update_relationships(product_id, 'brands', []);
```

### Carts, Orders and Payments

#### Carts - [Docs](https://moltin.api-docs.io/v2/carts)

Carts are automatically created when retrieving them. You need to pass a unique reference that will be used to get that cart later on.

```
# Get a cart (or create it if it doesn't exist)
cart = moltin.carts.get('unique_reference')
```

```
# Add a product
cart.add({ id: product_id }) # Adds one of the product identified by product_id
cart.add({ id: product_id, quantity: 3 }) # Adds 3 more - total is now 4
```

```
# Add a custom product
cart.add(
  name: 'Tax',
  sku: 'tax-calc',
  description: 'Custom tax calculation for this order',
  quantity: 1,
  price: {
   amount: 2000
  }
)
```

```
# Get all the items for a cart
moltin.carts.get('unique_reference').items

# Or if you have a cart object
cart.items
```

```
# Update an item
cart.update(cart_item_id, { quantity: 3 })
```

```
# Remove an item
cart.remove(cart_item_id)
```

A cart can be converted to an order (which can then be paid) with the `checkout` method:

```
# Create an order from a cart
customer = {}
billing = {}
shipping = {}

client.carts.checkout('unique_reference', customer: customer,
                                          billing: billing,
                                          shipping: shipping)

# Or if you have a cart object
cart = client.carts.get('unique_reference')
cart.checkout(customer: customer, billing: billing, shipping: shipping)                                          
```

#### Orders - [Docs](https://moltin.api-docs.io/v2/orders)

```
# Get all orders
moltin.orders.all

# Get a specific order
moltin.orders.get(id)

# Get an order items
moltin.orders.get(id).items

# Get an order transactions
moltin.orders.get(id).transactions
```

#### Payments - [Docs](https://moltin.api-docs.io/v2/paying-for-an-order)

Check the documentation for the parameters that can be sent through the `pay` method. They will be sent to the API as provided (the only change is a wrapping of the given hash under the `data` key).

```
# Paying for an order
order = moltin.orders.get(id)
payment = order.pay({
  gateway: 'stripe',
  method: 'purchase',
  first_name: 'John',
  last_name: 'Doe',
  number: '4242424242424242',
  month: '08',
  year: '2020',
  verification_value: '123'
})
```

### Handling Exceptions

Coming Soon.

### Example Application

Coming Soon.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/moltin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
