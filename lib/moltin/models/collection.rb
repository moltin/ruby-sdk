module Moltin
  module Models
    class Collection < Models::Base
      attributes :type, :id, :name, :slug, :description, :status, :meta
    end
  end
end
