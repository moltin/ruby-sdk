module Moltin
  module Models
    class Flow < Models::Base
      attributes :type, :id, :name, :slug, :description, :enabled, :links,
                 :meta, :relationships

      def fields
        client.fields(flow_slug: slug).all
      end

      def entries
        client.entries(flow_slug: slug)
      end
    end
  end
end
