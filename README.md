# Moltin

[![Travis Build Status](https://img.shields.io/travis/moltin/ruby-sdk.svg)](https://travis-ci.org/moltin/ruby-sdk)
[![Codecov Coverage](https://img.shields.io/codecov/c/github/moltin/ruby-sdk.svg)](https://codecov.io/github/moltin/ruby-sdk)

The Moltin ruby-sdk is a simple to use interface for the API to help you get off the ground quickly and efficiently within the Ruby Language.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moltin'
```

And then execute:

    $ bundle install



## Usage

### Configuration

```
Moltin::Config.api_version = 'beta'
Moltin::Config.api_host = 'api-test.moltin.dev'
```


### Authentication

We will automatically detect `ENV['MOLTIN_CLIENT_ID']` and `ENV['MOLTIN_CLIENT_SECRET']` variables, or you can pass them through manually. There is no need to call the authenticate method if ENV variables are set.

```
Moltin::Client::Authenticate('client_credentials', client_id: 'XXXXX', client_secret: 'XXXXX')
```


### CRUD Resources

The majority of our API calls can be mapped to Model-esque instance and don't need any low-level API calls.

```
// Create a product
product = Moltin::Resource::Product.create title: 'Example Product'

// Get a product
product = Moltin::Resource::Product.find 1

// Update a product
product.title = 'New Product Name'
product.save

// Delete a product
product.delete
```


### Manual API Request

For any API calls that aren't resources you can do the following

```
// Create a product
product = Moltin::Api::Request.post('product', title: 'Example Product').result

// Get a product
product = Moltin::Api::Request.get('product/123')

// Update a product
product = Moltin::Api::Request.put('product/123', title: 'New Product Name')

// Delete a product
product = Moltin::Api::Request.delete('product/123')
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.


## Testing

```
$ bundle exec rspec
```


## Contributing

1. Fork it ( https://github.com/moltin/ruby-sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
