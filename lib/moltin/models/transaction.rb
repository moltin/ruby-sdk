module Moltin
  module Models
    class Transaction < Models::Base
      attributes :type, :id, :reference, :gateway, :amount, :currency, :status,
                 :transaction_type
    end
  end
end
