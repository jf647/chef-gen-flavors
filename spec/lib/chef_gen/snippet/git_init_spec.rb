require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class GitInit < FlavorBase
      include ChefGen::Snippet::GitInit

      # :nocov:
      def self.description
        'my awesome template'
      end
      # :nocov:

      def self.code_generator_path(classfile)
        File.expand_path(
          File.join(
            classfile,
            '..', '..', '..', '..',
            'support', 'fixtures', 'code_generator'
          )
        )
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::GitInit do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should execute git init' do
    expect(@recipe).to receive(:execute).with('initialize git repo')
    template = ChefGen::Flavor::GitInit.new(@recipe)
    template.generate
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'git_init'
    ChefGen::Flavors.path
  end
end
