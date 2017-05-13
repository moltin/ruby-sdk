module Moltin
  class Client
    RESOURCES = {
      products: Moltin::Resources::Products,
      brands: Moltin::Resources::Brands,
      categories: Moltin::Resources::Categories,
      collections: Moltin::Resources::Collections,
      files: Moltin::Resources::Files,
      carts: Moltin::Resources::Carts,
      items: Moltin::Resources::CartItems,
      orders: Moltin::Resources::Orders,
      order_items: Moltin::Resources::OrderItems,
      transactions: Moltin::Resources::Transactions,
      payments: Moltin::Resources::Payments,
      gateways: Moltin::Resources::Gateways,
      integrations: Moltin::Resources::Integrations,
      variations: Moltin::Resources::Variations,
      variation_options: Moltin::Resources::VariationOptions,
      product_modifiers: Moltin::Resources::ProductModifiers,
      currencies: Moltin::Resources::Currencies,
      settings: Moltin::Resources::Settings,
      flows: Moltin::Resources::Flows,
      fields: Moltin::Resources::Fields,
      entries: Moltin::Resources::Entries
    }.freeze

    # The Moltin configuration.
    attr_reader :config, :storage
    attr_accessor :currency_code

    # Public: Create an instance of the SDK client,
    # using the options of the argument or the global configuration
    #
    # options - Hash of options to override in the global configuration
    #
    def initialize(options = nil)
      @config = load_config(options)
    end

    RESOURCES.each do |resource, klass|
      define_method resource do |options = {}|
        klass.new(@config, options, self)
      end
    end

    def currency(currency_code)
      @currency_code = currency_code
      self
    end

    private

    def load_config(options)
      return Moltin.configuration unless options

      config = Configuration.new
      config.merge(Moltin.configuration.to_hash.merge(options))
      config
    end
  end
end
