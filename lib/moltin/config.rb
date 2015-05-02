module Moltin
  class Config

    @api_version = '1.0'

    class << self
      attr_accessor :api_version
      attr_accessor :api_client_id
      attr_accessor :api_client_secret
    end

  end
end
