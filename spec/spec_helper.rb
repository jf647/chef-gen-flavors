require 'fakefs/spec_helpers'
require 'rspec/core/shared_context'
require 'chef-dk/generator'

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

# a shared context that stubs a ChefDK Generator context
module ChefDKGeneratorContext
  extend RSpec::Core::SharedContext

  before do
    @ctx = double('ChefDK generator context')
    allow(@ctx).to receive(:cookbook_root).and_return('/nonexistent')
    allow(@ctx).to receive(:cookbook_name).and_return('foo')
    allow(@ctx).to receive(:have_git).and_return(true)
    allow(@ctx).to receive(:skip_git_init).and_return(false)
    allow(@ctx).to receive(:generator_path).and_return('/nonexistent')
    allow(@ctx).to receive(:generator_path=)
    allow(ChefDK::Generator).to receive(:context).and_return(@ctx)
  end
end

# a shared context that allows a recipe double to receive unknown methods
module DummyRecipe
  extend RSpec::Core::SharedContext

  before do
    @recipe = double('Chef recipe').as_null_object
  end
end

# a shared context that redirects stdout/stderr to null
module StdQuiet
  extend RSpec::Core::SharedContext

  before do
    @orig_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stdout = @orig_stdout
  end
end

# a shared context that resets the flavor plugins
module ResetPlugins
  extend RSpec::Core::SharedContext

  before do
    ChefGen::Flavors.clear_plugins
    ENV.delete('CHEFGEN_FLAVOR')
    ENV.delete('CHEFDK_FLAVOR')
  end
end
