require 'faraday'
require 'json'
require 'open-uri'

require_relative 'moltin/models/base'
require_relative 'moltin/models/attribute'
require_relative 'moltin/models/brand'
require_relative 'moltin/models/category'
require_relative 'moltin/models/collection'
require_relative 'moltin/models/file'
require_relative 'moltin/models/product'
require_relative 'moltin/models/cart'
require_relative 'moltin/models/cart_item'
require_relative 'moltin/models/order_item'
require_relative 'moltin/models/order'
require_relative 'moltin/models/transaction'
require_relative 'moltin/models/payment'
require_relative 'moltin/models/gateway'
require_relative 'moltin/models/integration'
require_relative 'moltin/models/variation'
require_relative 'moltin/models/variation_option'
require_relative 'moltin/models/product_modifier'
require_relative 'moltin/models/currency'
require_relative 'moltin/models/setting'
require_relative 'moltin/models/flow'
require_relative 'moltin/models/field'
require_relative 'moltin/models/entry'
require_relative 'moltin/models/included'

require_relative 'moltin/version'
require_relative 'moltin/configuration'

require_relative 'moltin/errors/authentication_error'
require_relative 'moltin/errors/invalid_relationship_error'
require_relative 'moltin/errors/undefined_criteria'
require_relative 'moltin/errors/unsupported_action_error'
require_relative 'moltin/errors/invalid_body'

require_relative 'moltin/utils/request'
require_relative 'moltin/utils/response'
require_relative 'moltin/utils/access_token'
require_relative 'moltin/utils/criteria'

require_relative 'moltin/resources/base'
require_relative 'moltin/resources/brands'
require_relative 'moltin/resources/categories'
require_relative 'moltin/resources/collections'
require_relative 'moltin/resources/files'
require_relative 'moltin/resources/products'
require_relative 'moltin/resources/carts'
require_relative 'moltin/resources/cart_items'
require_relative 'moltin/resources/order_items'
require_relative 'moltin/resources/orders'
require_relative 'moltin/resources/transactions'
require_relative 'moltin/resources/payments'
require_relative 'moltin/resources/gateways'
require_relative 'moltin/resources/integrations'
require_relative 'moltin/resources/variations'
require_relative 'moltin/resources/variation_options'
require_relative 'moltin/resources/product_modifiers'
require_relative 'moltin/resources/currencies'
require_relative 'moltin/resources/settings'
require_relative 'moltin/resources/flows'
require_relative 'moltin/resources/fields'
require_relative 'moltin/resources/entries'

require_relative 'moltin/client'

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
