module Moltin
  class ResourceCollection
    include Enumerable
    @resources = []

    def initialize(resource_class, data)
      data ||= {}
      @resources = data.map do |result|
        resource_class.constantize.new result
      end
    end

    def each(&block)
      @resources.each(&block)
    end
  end
end
