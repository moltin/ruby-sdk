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

### Resources (Products, more coming soon)

#### Retrieve a list of resources (GET)

```
moltin.products.all
# => [Moltin::Models::Product, Moltin::Models::Product]
```

#### Customizing the requests

The requests to retrieve data from the API can be configured for pagination, sorting, filtering and including related resources.

Check the [API docs](https://moltin.api-docs.io/v2/using-the-api) for the up-to-date options available for each type of resource.

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

##### Fetching the category/brand/collection tree

Coming Soon.

#### Retrieve a single resource (GET)

##### Products

```
moltin.products.get(product_id)
```

#### Create a resource (POST)

##### Products

```
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

#### Update a resource (POST)

##### Products

```
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

#### delete a resource (POST)

##### Products

```
moltin.products.delete(product_id)
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

### Files

Coming Soon.

### Carts, Orders and Payments

Coming Soon.

### Handling Exceptions

Coming Soon.

### Examples

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
