module Moltin
  module Models
    class Currency < Models::Base
      attributes :type, :id, :code, :exchange_rate, :format, :decimal_point,
                 :thousand_separator, :decimal_places, :default, :enabled,
                 :links, :meta
    end
  end
end
