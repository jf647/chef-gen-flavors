require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class StandardIgnore < FlavorBase
      include ChefGen::Snippet::StandardIgnore

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

RSpec.describe ChefGen::Snippet::StandardIgnore do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should create a chefignore file' do
    expect(@recipe).to receive(:file).with(/chefignore$/)
    template = ChefGen::Flavor::StandardIgnore.new(@recipe)
    template.generate
  end

  it 'should create a .gitignore file' do
    expect(@recipe).to receive(:file).with(/.gitignore$/)
    template = ChefGen::Flavor::StandardIgnore.new(@recipe)
    template.generate
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'standard_ignore'
    ChefGen::Flavors.path
  end
end
