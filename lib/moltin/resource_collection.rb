module Moltin
  class ResourceCollection
    @resources = []

    def initialize(resource_class, data)
      @resources = data.map do |result|
        resource_class.constantize.new result
      end
    end

    def to_s
      @resources.map(&:to_s)
    end
  end
end
