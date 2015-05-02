module Moltin
  class Config

    @api_host = 'api.molt.in'
    @api_version = 'v1'

    class << self
      attr_accessor :api_host
      attr_accessor :api_version
      attr_accessor :api_client_id
      attr_accessor :api_client_secret
    end

  end
end
