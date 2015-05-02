module Moltin
  module Support
    class Inflector

      def self.pluralize(term)
        plurals = {
          "address" => "addresses",
          "category" => "categories",
          "currency" => "currencies",
          "tax" => "taxes",
        }
        plurals[term] || "#{term}s"
      end

    end
  end
end
