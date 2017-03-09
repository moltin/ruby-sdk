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

## Usage

Coming Soon.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/moltin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
