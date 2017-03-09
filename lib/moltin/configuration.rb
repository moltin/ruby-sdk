module Moltin
  class Configuration
    OPTIONS = {
      # Authentication Params
      client_id: -> { ENV['MOLTIN_CLIENT_ID'] },
      client_secret: -> { ENV['MOLTIN_CLIENT_SECRET'] },

      # API Endpoints Configuration
      base_url: 'https://api.moltin.com'
    }.freeze

    MOLTIN_OPTIONS = {
      version: 'v2',
      auth_uri: 'oauth/access_token'
    }.freeze

    # Setting all the OPTIONS keys as attributes
    attr_accessor(*OPTIONS.keys)
    attr_reader(*MOLTIN_OPTIONS.keys)

    def initialize
      # Initializing each attribute with its default value.
      # These values can be overridden with merge or #{attribute}=.
      # base_url is reserved for enterprise customers.
      OPTIONS.merge(MOLTIN_OPTIONS).each do |name, val|
        value = val.respond_to?(:lambda?) && val.lambda? ? val.call : val
        instance_variable_set("@#{name}", value)
      end
    end

    # Public: Allows config options to be read like a hash
    #
    # option - Key for a given attribute
    #
    # Returns value of requested attribute
    def [](option)
      send(option)
    end

    # Public
    # Returns a hash of all configurable options
    def to_hash
      OPTIONS.keys.inject({}) do |hash, option|
        hash[option.to_sym] = send(option)
        hash
      end
    end

    # Public: Merge the given options into the current set of attributes
    #
    # options - Hash containing values to be updated
    #
    # Returns the current object
    def merge(options)
      OPTIONS.keys.each do |name|
        instance_variable_set("@#{name}", options[name]) if options[name]
      end
    end
  end
end
