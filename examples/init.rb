require 'awesome_print'
require 'securerandom'
require 'logger'

require_relative '../lib/moltin'

Moltin.configure do |config|
  config.client_id = 'YOUR_CLIENT_ID'
  config.client_secret = 'YOUR_CLIENT_SECRET'
  config.currency_code = 'USD'
  config.language = 'en'
  config.locale = 'en_us'
  config.storage = {}
end
