require 'faraday'
require 'JSON'

body = {
  grant_type: 'client_credentials',
  client_id: 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc',
  client_secret: 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'
}

headers = {
  'Content-Type' => 'application/x-www-form-urlencoded'
}

# Net::HTTP.post_form URI("https://api.moltin.com/oauth/access_token"), body, headers
conn = Faraday.new(url: 'https://api.moltin.com')
response = conn.post '/oauth/access_token', body

p JSON.parse(response.body)
