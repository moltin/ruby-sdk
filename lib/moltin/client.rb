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
      integrations: Moltin::Resources::Integrations
    }.freeze

    # The Moltin configuration.
    attr_reader :config, :storage

    # Public: Create an instance of the SDK client,
    # using the options of the argument or the global configuration
    #
    # options - Hash of options to override in the global configuration
    #
    def initialize(options = nil)
      @config = load_config(options)
      @storage = {}
    end

    RESOURCES.each do |resource, klass|
      define_method resource do |options = {}|
        klass.new(@config, @storage, options, self)
      end
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
