require 'chef-dk/template/plugin'

# sample plugins
require 'support/fixtures/lib/chef-dk/template/plugin/foo'
require 'support/fixtures/lib/chef-dk/template/plugin/bar'
require 'support/fixtures/lib/chef-dk/template/plugin/baz'

RSpec.describe ChefDK::Template::Plugin do
  before do
    ChefDK::Template::Plugin.clear_plugins
    ENV.delete('CHEFDK_TEMPLATE')
    ENV.delete('CHEFDK_TEMPLATE_BUILTIN')
    @orig_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stdout = @orig_stdout
  end

  it 'should be able to load plugins' do
    expect(ChefDK::Template::Plugin.plugins).to be_a(Hash)
  end

  it 'should load the expected plugins' do
    ChefDK::Template::Plugin.disregard_plugin :amazing, :awesome
    expect(ChefDK::Template::Plugin.plugins.keys).to(
      contain_exactly(:foo, :bar, :baz)
    )
  end

  it 'allows for the plugin list to be make explicit' do
    ChefDK::Template::Plugin.plugin :foo
    expect(ChefDK::Template::Plugin.plugins).to include(:foo)
    expect(ChefDK::Template::Plugin.plugins).not_to include(:bar)
  end

  it 'allows for plugins to be blacklisted' do
    ChefDK::Template::Plugin.disregard_plugin :foo, :baz
    expect(ChefDK::Template::Plugin.plugins).not_to include(:foo)
    expect(ChefDK::Template::Plugin.plugins).to include(:bar)
  end

  it 'should not prompt for a plugin if only one is available' do
    ChefDK::Template::Plugin.plugin :foo
    expect(ChefDK::Template::Plugin).not_to receive(:prompt_for_plugin)
    ChefDK::Template::Plugin.path
  end

  it 'should not prompt for a plugin if the env var matches one' do
    ChefDK::Template::Plugin.disregard_plugin :baz
    ENV['CHEFDK_TEMPLATE'] = 'Foo'
    expect(ChefDK::Template::Plugin).not_to receive(:prompt_for_plugin)
    ChefDK::Template::Plugin.path
  end

  it 'should be case insensitive when selecting the plugin via env var' do
    ChefDK::Template::Plugin.disregard_plugin :baz
    ENV['CHEFDK_TEMPLATE'] = 'foo'
    expect(ChefDK::Template::Plugin).not_to receive(:prompt_for_plugin)
    ChefDK::Template::Plugin.path
    ENV.delete('CHEFDK_TEMPLATE')
  end

  it 'should prompt for a plugin if the env var does not match' do
    ChefDK::Template::Plugin.disregard_plugin :baz
    ENV['CHEFDK_TEMPLATE'] = 'Gzonk'
    expect(ChefDK::Template::Plugin)
      .to receive(:prompt_for_plugin)
      .and_return(:foo)
    ChefDK::Template::Plugin.path
  end

  it 'should prompt for a plugin if the env var is not set' do
    ChefDK::Template::Plugin.disregard_plugin :baz
    expect(ChefDK::Template::Plugin)
      .to receive(:prompt_for_plugin)
      .and_return(:bar)
    ChefDK::Template::Plugin.path
  end

  it 'should raise an error if there are no plugins available' do
    ChefDK::Template::Plugin.disregard_plugin :foo, :bar, :baz,
                                              :amazing, :awesome
    expect { ChefDK::Template::Plugin.path }.to raise_error
  end

  it 'should offer the builtin template as an option with the env var set' do
    ENV['CHEFDK_TEMPLATE_BUILTIN'] = 'true'
    ChefDK::Template::Plugin.disregard_plugin :foo, :bar, :baz,
                                              :amazing, :awesome
    expect(ChefDK::Template::Plugin).not_to receive(:prompt_for_plugin)
    ChefDK::Template::Plugin.path
  end

  it 'should raise an error if the plugin has no description' do
    ENV['CHEFDK_TEMPLATE'] = 'Baz'
    expect { ChefDK::Template::Plugin.path }.to raise_error
  end

  it 'should default the code_generator path' do
    ChefDK::Template::Plugin.disregard_plugin :baz
    ENV['CHEFDK_TEMPLATE'] = 'Foo'
    expect(ChefDK::Template::Plugin.path)
      .to match(%r{spec/support/fixtures/code_generator$})
  end

  it 'should respect an overridden code_generator path' do
    ChefDK::Template::Plugin.disregard_plugin :baz
    ENV['CHEFDK_TEMPLATE'] = 'Bar'
    expect(ChefDK::Template::Plugin.path)
      .to match(%r{spec/support/fixtures/code_generator_2$})
  end
end
