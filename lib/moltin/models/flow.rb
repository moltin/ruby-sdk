module Moltin
  module Models
    class Flow < Models::Base
      attributes :type, :id, :name, :slug, :description, :enabled, :links,
                 :meta, :relationships

      def fields
        client.fields(flow_slug: slug).all
      end
    end
  end
end
