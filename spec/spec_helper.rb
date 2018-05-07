require 'bundler/setup'
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'lib/audited_async/version'
end
SimpleCov.minimum_coverage ENV.fetch('COVERAGE_THRESHOLD', '100').to_i
SimpleCov.at_exit do
  SimpleCov.result.format!
end

require 'audited_async'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
