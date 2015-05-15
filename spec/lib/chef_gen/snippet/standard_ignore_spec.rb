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
  include ChefDKGeneratorContext
  include DummyRecipe

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
