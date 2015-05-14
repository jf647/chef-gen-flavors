require 'chef_gen/template'

# sample plugins
require 'support/fixtures/lib/chef_gen/flavor/foo'
require 'support/fixtures/lib/chef_gen/flavor/bar'
require 'support/fixtures/lib/chef_gen/flavor/baz'

RSpec.describe ChefGen::Template do
  before do
    ChefGen::Template.clear_plugins
    ENV.delete('CHEFGEN_TEMPLATE')
    ENV.delete('CHEFDK_BUILTIN_TEMPLATE')
    @orig_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stdout = @orig_stdout
  end

  it 'should be able to load plugins' do
    expect(ChefGen::Template.plugins).to be_a(Hash)
  end

  it 'should load the expected plugins' do
    ChefGen::Template.disregard_plugin :amazing, :awesome
    expect(ChefGen::Template.plugins.keys).to(
      contain_exactly(:foo, :bar, :baz)
    )
  end

  it 'allows for the plugin list to be make explicit' do
    ChefGen::Template.plugin :foo
    expect(ChefGen::Template.plugins).to include(:foo)
    expect(ChefGen::Template.plugins).not_to include(:bar)
  end

  it 'allows for plugins to be blacklisted' do
    ChefGen::Template.disregard_plugin :foo, :baz
    expect(ChefGen::Template.plugins).not_to include(:foo)
    expect(ChefGen::Template.plugins).to include(:bar)
  end

  it 'should not prompt for a plugin if only one is available' do
    ChefGen::Template.plugin :foo
    expect(ChefGen::Template).not_to receive(:prompt_for_plugin)
    ChefGen::Template.path
  end

  it 'should not prompt for a plugin if the env var matches one' do
    ChefGen::Template.disregard_plugin :baz
    ENV['CHEFGEN_TEMPLATE'] = 'Foo'
    expect(ChefGen::Template).not_to receive(:prompt_for_plugin)
    ChefGen::Template.path
  end

  it 'should be case insensitive when selecting the plugin via env var' do
    ChefGen::Template.disregard_plugin :baz
    ENV['CHEFGEN_TEMPLATE'] = 'foo'
    expect(ChefGen::Template).not_to receive(:prompt_for_plugin)
    ChefGen::Template.path
    ENV.delete('CHEFGEN_TEMPLATE')
  end

  it 'should prompt for a plugin if the env var does not match' do
    ChefGen::Template.disregard_plugin :baz
    ENV['CHEFGEN_TEMPLATE'] = 'Gzonk'
    expect(ChefGen::Template)
      .to receive(:prompt_for_plugin)
      .and_return(:foo)
    ChefGen::Template.path
  end

  it 'should prompt for a plugin if the env var is not set' do
    ChefGen::Template.disregard_plugin :baz
    expect(ChefGen::Template)
      .to receive(:prompt_for_plugin)
      .and_return(:bar)
    ChefGen::Template.path
  end

  it 'should raise an error if there are no plugins available' do
    ChefGen::Template.disregard_plugin :foo, :bar, :baz,
                                       :amazing, :awesome
    expect { ChefGen::Template.path }.to raise_error
  end

  it 'should offer the builtin template as an option with the env var set' do
    ENV['CHEFDK_BUILTIN_TEMPLATE'] = 'true'
    ChefGen::Template.disregard_plugin :foo, :bar, :baz,
                                       :amazing, :awesome
    expect(ChefGen::Template).not_to receive(:prompt_for_plugin)
    ChefGen::Template.path
  end

  it 'should raise an error if the plugin has no description' do
    ENV['CHEFGEN_TEMPLATE'] = 'Baz'
    expect { ChefGen::Template.path }.to raise_error
  end

  it 'should default the code_generator path' do
    ChefGen::Template.disregard_plugin :baz
    ENV['CHEFGEN_TEMPLATE'] = 'Foo'
    expect(ChefGen::Template.path)
      .to match(%r{spec/support/fixtures/code_generator$})
  end

  it 'should respect an overridden code_generator path' do
    ChefGen::Template.disregard_plugin :baz
    ENV['CHEFGEN_TEMPLATE'] = 'Bar'
    expect(ChefGen::Template.path)
      .to match(%r{spec/support/fixtures/code_generator_2$})
  end
end
