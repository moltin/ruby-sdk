module Moltin
  module Resources
    class Carts < Resources::Base
      def all
        raise Errors::UnsupportedActionError.new(
          'Can\'t get the list of carts.'
        )
      end

      def create(_data)
        raise Errors::UnsupportedActionError.new(
          'Can\'t create a cart.'
        )
      end

      def update(_id, _data)
        raise Errors::UnsupportedActionError.new(
          'Can\'t update a cart.'
        )
      end

      def checkout(id, data)
        response(call(:post, "#{uri}/#{id}/checkout", data: data), model: Moltin::Models::Order)
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'cart'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Cart
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/carts"
      end
    end
  end
end
