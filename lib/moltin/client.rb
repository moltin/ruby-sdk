module Moltin
  class Client
    RESOURCES = {
      products: Moltin::Resources::Product
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
      define_method resource do
        klass.new(@config, @storage)
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
