module Moltin
  module Models
    class Category < Models::Base
      attributes :type, :id, :name, :slug, :description, :status, :meta

      has_many :categories
      has_many :children
      belongs_to :parent
    end
  end
end
