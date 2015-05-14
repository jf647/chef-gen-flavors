require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < FlavorBase
      include ChefGen::Snippet::StandardIgnore

      class << self
        # :nocov:
        def description
          'my awesome template'
        end
        # :nocov:
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::StandardIgnore do
  before do
    @ctx = double('ChefDK generator context')
    allow(@ctx).to receive(:cookbook_root).and_return('/nonexistent')
    allow(@ctx).to receive(:cookbook_name).and_return('foo')
    allow(ChefDK::Generator).to receive(:context).and_return(@ctx)
    @recipe = double('Chef recipe').as_null_object
  end

  it 'should create a chefignore file' do
    expect(@recipe).to receive(:file).with(/chefignore$/)
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
  end

  it 'should create a .gitignore file' do
    expect(@recipe).to receive(:file).with(/\.gitignore$/)
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
  end
end
