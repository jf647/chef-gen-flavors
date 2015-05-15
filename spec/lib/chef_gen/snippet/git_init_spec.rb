require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < FlavorBase
      include ChefGen::Snippet::GitInit

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

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::GitInit do
  include ChefDKGeneratorContext
  include DummyRecipe

  it 'should execute git init' do
    expect(@recipe).to receive(:execute).with('initialize git repo')
    template = ChefGen::Flavor::Awesome.new(@recipe)
    template.generate
  end
end
