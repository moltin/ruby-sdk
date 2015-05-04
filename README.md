# Moltin

The Moltin ruby-sdk is a simple to use interface for the API to help you get off the ground quickly and efficiently within the Ruby Language.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moltin'
```

And then execute:

    $ bundle

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

### Get A CRUD Resource

The majority of our API calls can be mapped to Model-esque instance and don't need any low-level API calls.

```
product = Moltin::Resource::Product.find(1)
puts product.name # Name of Product
product.price = 200
product.save
```

### Manual API Request

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/moltin/ruby-sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
