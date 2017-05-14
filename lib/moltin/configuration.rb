module Moltin
  class Configuration
    OPTIONS = {
      # Authentication Params
      client_id: -> { ENV['MOLTIN_CLIENT_ID'] },
      client_secret: -> { ENV['MOLTIN_CLIENT_SECRET'] },

      # API Endpoints Configuration
      base_url: 'https://api.moltin.com',

      # Headers
      currency_code: 'USD',
      language: 'en',
      locale: 'en_gb',

      storage: {},
      logger: nil
    }.freeze

    MOLTIN_OPTIONS = {
      version: 'v2',
      auth_uri: 'oauth/access_token',
      resources: {
        brands: { name: 'brand', model: Moltin::Models::Brand },
        cart_items: { name: 'cart-item', model: Moltin::Models::CartItem },
        carts: { name: 'cart', model: Moltin::Models::Cart },
        categories: { name: 'category', model: Moltin::Models::Category },
        collections: { name: 'collection', model: Moltin::Models::Collection },
        currencies: { name: 'currencies', model: Moltin::Models::Currency },
        entries: { name: 'entry', model: Moltin::Models::Entry },
        fields: { name: 'field', model: Moltin::Models::Field },
        files: { name: 'file', model: Moltin::Models::File },
        flows: { name: 'flow', model: Moltin::Models::Flow },
        gateways: { name: 'gateway', model: Moltin::Models::Gateway },
        integrations: { name: 'integration', model: Moltin::Models::Integration },
        order_items: { name: 'order-item', model: Moltin::Models::OrderItem },
        orders: { name: 'order', model: Moltin::Models::Order },
        payments: { name: 'payment', model: Moltin::Models::Payment },
        product_modifiers: { name: 'product-modifier', model: Moltin::Models::ProductModifier },
        products: { name: 'product', model: Moltin::Models::Brand },
        settings: { name: 'setting', model: Moltin::Models::Setting },
        transactions: { name: 'transaction', model: Moltin::Models::Transaction },
        variation_options: { name: 'variation-option', model: Moltin::Models::VariationOption },
        variations: { name: 'product-variation', model: Moltin::Models::Variation },
        product_variations: { name: 'product-variation', model: Moltin::Models::Variation },

        brand: { name: 'brand', model: Moltin::Models::Brand },
        cart_item: { name: 'cart-item', model: Moltin::Models::CartItem },
        cart: { name: 'cart', model: Moltin::Models::Cart },
        category: { name: 'category', model: Moltin::Models::Category },
        collection: { name: 'collection', model: Moltin::Models::Collection },
        currencie: { name: 'currencies', model: Moltin::Models::Currency },
        entry: { name: 'entry', model: Moltin::Models::Entry },
        field: { name: 'field', model: Moltin::Models::Field },
        file: { name: 'file', model: Moltin::Models::File },
        flow: { name: 'flow', model: Moltin::Models::Flow },
        gateway: { name: 'gateway', model: Moltin::Models::Gateway },
        integration: { name: 'integration', model: Moltin::Models::Integration },
        order_item: { name: 'order-item', model: Moltin::Models::OrderItem },
        order: { name: 'order', model: Moltin::Models::Order },
        payment: { name: 'payment', model: Moltin::Models::Payment },
        product_modifier: { name: 'product-modifier', model: Moltin::Models::ProductModifier },
        product: { name: 'product', model: Moltin::Models::Brand },
        setting: { name: 'setting', model: Moltin::Models::Setting },
        transaction: { name: 'transaction', model: Moltin::Models::Transaction },
        variation_option: { name: 'variation-option', model: Moltin::Models::VariationOption },
        variation: { name: 'product-variation', model: Moltin::Models::Variation },
        product_variation: { name: 'product-variation', model: Moltin::Models::Variation },
        parent: { name: 'category', model: Moltin::Models::Category },
        children: { name: 'category', model: Moltin::Models::Category }
      }
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
      OPTIONS.keys.each_with_object({}) do |option, hash|
        hash[option.to_sym] = send(option)
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
