module Moltin
  module Models
    class Setting < Models::Base
      attributes :type, :page_length, :return_variations, :quantity_greater_stock,
                 :timezone, :password_policy
    end
  end
end
