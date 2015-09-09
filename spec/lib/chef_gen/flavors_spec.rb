require 'chef_gen/flavors'

# sample plugins
require 'support/fixtures/lib/chef_gen/flavor/foo'
require 'support/fixtures/lib/chef_gen/flavor/bar'
require 'support/fixtures/lib/chef_gen/flavor/baz'

RSpec.describe ChefGen::Flavors do
  include ChefDKGeneratorContext
  include StdQuiet
  include ResetPlugins

  it 'should be able to load plugins' do
    expect(ChefGen::Flavors.plugins).to be_a(Hash)
  end

  it 'should load the expected plugins' do
    expect(ChefGen::Flavors.plugins.keys).to(
      include(:foo, :bar, :baz)
    )
  end

  it 'allows for the plugin list to be make explicit' do
    ChefGen::Flavors.plugin :foo
    expect(ChefGen::Flavors.plugins).to include(:foo)
    expect(ChefGen::Flavors.plugins).not_to include(:bar)
  end

  it 'allows for plugins to be blacklisted' do
    ChefGen::Flavors.disregard_plugin :foo, :baz
    expect(ChefGen::Flavors.plugins).not_to include(:foo)
    expect(ChefGen::Flavors.plugins).to include(:bar)
  end

  it 'should not prompt for a plugin if only one is available' do
    ChefGen::Flavors.plugin :foo
    expect(ChefGen::Flavors).not_to receive(:prompt_for_plugin)
    ChefGen::Flavors.path
  end

  it 'should not prompt for a plugin if the env var matches one' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'Foo'
    expect(ChefGen::Flavors).not_to receive(:prompt_for_plugin)
    ChefGen::Flavors.path
  end

  it 'should be case insensitive when selecting the plugin via env var' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'foo'
    expect(ChefGen::Flavors).not_to receive(:prompt_for_plugin)
    ChefGen::Flavors.path
    ENV.delete('CHEFGEN_FLAVOR')
  end

  it 'should prompt for a plugin if the env var does not match' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'Gzonk'
    expect(ChefGen::Flavors)
      .to receive(:prompt_for_plugin)
      .and_return(:foo)
    ChefGen::Flavors.path
  end

  it 'should prompt for a plugin if the env var is not set' do
    ChefGen::Flavors.disregard_plugin :baz
    expect(ChefGen::Flavors)
      .to receive(:prompt_for_plugin)
      .and_return(:bar)
    ChefGen::Flavors.path
  end

  it 'should raise an error if there are no plugins available' do
    to_disregard = ChefGen::Flavors.plugins.keys
    ChefGen::Flavors.clear_plugins
    to_disregard.each do |plugin|
      ChefGen::Flavors.disregard_plugin plugin
    end
    expect { ChefGen::Flavors.path }.to raise_error(RuntimeError)
  end

  it 'should use the builtin flavor as an option with the env var set' do
    ENV['CHEFDK_FLAVOR'] = 'true'
    to_disregard = ChefGen::Flavors.plugins.keys
    ChefGen::Flavors.clear_plugins
    to_disregard.each do |plugin|
      ChefGen::Flavors.disregard_plugin plugin
    end
    expect(ChefGen::Flavors).not_to receive(:prompt_for_plugin)
    ChefGen::Flavors.path
  end
end
