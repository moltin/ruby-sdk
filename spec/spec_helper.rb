require 'simplecov'
SimpleCov.start

require 'pry-byebug'
require 'bundler/setup'
require 'webmock/rspec'
require 'vcr'
require 'moltin'

ENV['FAKE_CLIENT_ID'] = 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc'
ENV['FAKE_CLIENT_SECRET'] = 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end
