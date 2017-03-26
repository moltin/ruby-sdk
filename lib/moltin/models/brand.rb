module Moltin
  module Models
    class Brand < Models::Base
      attributes :type, :id, :name, :slug, :status, :description, :links, :meta
    end
  end
end
