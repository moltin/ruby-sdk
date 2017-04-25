require 'simplecov'
SimpleCov.start

require 'pry-byebug'
require 'bundler/setup'
require 'webmock/rspec'
require 'vcr'
require 'timecop'
require 'moltin'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around(:each, freeze_time: true) do |example|
    Timecop.freeze(Date.today - 30 * 12 * 3 * 10) do
      example.run
    end
  end

  config.around(:each) do |example|
    ENV['MOLTIN_CLIENT_ID'] = 'FTtrUHsKHstAOtAhN2VjKbpvK08ZXOKZ0GAQaiIAcc'
    ENV['MOLTIN_CLIENT_SECRET'] = 'iFUwmVrwIOWwJrSR70gUtNQ5vIKRwc2RJVyXdid4tc'

    example.run

    ENV.delete('MOLTIN_CLIENT_ID')
    ENV.delete('MOLTIN_CLIENT_SECRET')
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end
