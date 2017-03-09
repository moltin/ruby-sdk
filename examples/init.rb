require 'moltin'

Moltin.configure do |config|
  config.client_id = 'YOUR_CLIENT_ID'
  config.client_secret = 'YOUR_CLIENT_SECRET'
  config.base_url = 'https://api.yourdomain.com'
end

Moltin::Client.new(client_id: 'YOUR_CLIENT_ID',
                   client_secret: 'YOUR_CLIENT_SECRET',
                   base_url:  'https://api.yourdomain.com')
