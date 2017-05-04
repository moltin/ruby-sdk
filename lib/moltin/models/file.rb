module Moltin
  module Models
    class File < Models::Base
      attributes :type, :id, :link, :file_name, :mime_type, :file_size, :public,
                 :meta

      def href
        link['href']
      end
    end
  end
end
