ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"
require "vcr"

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('app', 'test', 'fixtures', 'vcr_cassettes')
  config.hook_into :webmock
end

class ActiveSupport::TestCase

end
