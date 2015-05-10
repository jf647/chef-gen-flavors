if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
  SimpleCov.start do
    add_filter 'spec/support/fixtures'
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end

# LittlePlugger doesn't expect to have its inclusion/exclusion
# lists reset in a single process, so we have to monkeypatch
# in some testing functionality
module LittlePlugger
  module ClassMethods
    def clear_plugins
      @plugin_names = []
      @disregard_plugin = []
      @loaded = {}
    end
  end
end
