module Moltin
  module Models
    class Gateway < Models::Base
      attributes :type, :id, :enabled, :login, :name, :slug
    end
  end
end
