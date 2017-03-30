require 'faraday'

require 'moltin/version'
require 'moltin/configuration'

require 'moltin/errors/authentication_error'

require 'moltin/utils/request'
require 'moltin/utils/response'
require 'moltin/utils/access_token'
require 'moltin/utils/criteria'

require 'moltin/models/base'
require 'moltin/models/attribute'
require 'moltin/models/product'

require 'moltin/resources/base'
require 'moltin/resources/products'

require 'moltin/client'

module Moltin
  class << self
    attr_writer :configuration

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
