require 'faraday'
require 'json'
require 'open-uri'

require 'moltin/models/base'
require 'moltin/models/attribute'
require 'moltin/models/brand'
require 'moltin/models/category'
require 'moltin/models/collection'
require 'moltin/models/file'
require 'moltin/models/product'
require 'moltin/models/cart'
require 'moltin/models/cart_item'
require 'moltin/models/order_item'
require 'moltin/models/order'
require 'moltin/models/transaction'
require 'moltin/models/payment'
require 'moltin/models/gateway'
require 'moltin/models/integration'
require 'moltin/models/variation'
require 'moltin/models/variation_option'
require 'moltin/models/product_modifier'
require 'moltin/models/currency'
require 'moltin/models/setting'
require 'moltin/models/flow'
require 'moltin/models/field'
require 'moltin/models/entry'
require 'moltin/models/included'

require 'moltin/version'
require 'moltin/configuration'

require 'moltin/errors/authentication_error'
require 'moltin/errors/invalid_relationship_error'
require 'moltin/errors/undefined_criteria'
require 'moltin/errors/unsupported_action_error'

require 'moltin/utils/request'
require 'moltin/utils/response'
require 'moltin/utils/access_token'
require 'moltin/utils/criteria'

require 'moltin/resources/base'
require 'moltin/resources/brands'
require 'moltin/resources/categories'
require 'moltin/resources/collections'
require 'moltin/resources/files'
require 'moltin/resources/products'
require 'moltin/resources/carts'
require 'moltin/resources/cart_items'
require 'moltin/resources/order_items'
require 'moltin/resources/orders'
require 'moltin/resources/transactions'
require 'moltin/resources/payments'
require 'moltin/resources/gateways'
require 'moltin/resources/integrations'
require 'moltin/resources/variations'
require 'moltin/resources/variation_options'
require 'moltin/resources/product_modifiers'
require 'moltin/resources/currencies'
require 'moltin/resources/settings'
require 'moltin/resources/flows'
require 'moltin/resources/fields'
require 'moltin/resources/entries'

require 'moltin/client'

module Moltin
  class << self
    attr_writer :configuration

    def root
      File.expand_path '../..', __FILE__
    end

    # A Moltin configuration object. Must act like a hash and return values
    # for all Moltin configuration options. See Moltin::Configuration.
    def configuration
      @configuration ||= Configuration.new
    end

    # Public: Call this method to modify defaults in your initializers.
    #
    # Examples:
    #
    #   Moltin.configure do |config|
    #     config.client_id = '123'
    #     config.client_secret  = '456'
    #   end
    #
    # Yields Moltin configuration
    def configure
      yield(configuration)
    end
  end
end
