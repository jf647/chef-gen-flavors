require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class StyleFoodcritic < FlavorBase
      include ChefGen::Snippet::CookbookBase
      include ChefGen::Snippet::StyleFoodcritic

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

RSpec.describe ChefGen::Snippet::StyleFoodcritic do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should add the foodcritic gems' do
    template = ChefGen::Flavor::StyleFoodcritic.new(@recipe)
    template.generate
    expect(template.cookbook_gems.keys).to include('foodcritic')
    expect(template.cookbook_gems.keys).to include('guard-foodcritic')
  end

  it 'should add the foodcritic rake tasks' do
    template = ChefGen::Flavor::StyleFoodcritic.new(@recipe)
    template.generate
    expect(template.rake_tasks.keys).to include('foodcritic')
  end

  it 'should add the foodcritic guard sets' do
    template = ChefGen::Flavor::StyleFoodcritic.new(@recipe)
    template.generate
    expect(template.guard_sets.keys).to include('foodcritic')
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'style_foodcritic'
    ChefGen::Flavors.path
  end
end
