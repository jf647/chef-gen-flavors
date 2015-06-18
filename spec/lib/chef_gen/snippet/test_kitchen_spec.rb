require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class TestKitchen < FlavorBase
      include ChefGen::Snippet::CookbookBase
      include ChefGen::Snippet::TestKitchen

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
RSpec.describe ChefGen::Snippet::TestKitchen do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  %w(test test/integration test/integration/default
     test/integration/default/serverspec
     test/integration/default/serverspec/recipes).each do |dname|
    it "should create the directory #{dname}" do
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      template = ChefGen::Flavor::TestKitchen.new(@recipe)
      template.generate
    end
  end

  %w(.kitchen.yml test/integration/default/serverspec/spec_helper.rb
     test/integration/default/serverspec/recipes/default_spec.rb)
    .each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      template = ChefGen::Flavor::TestKitchen.new(@recipe)
      template.generate
    end
  end

  it 'should add the testkitchen gems' do
    template = ChefGen::Flavor::TestKitchen.new(@recipe)
    template.generate
    expect(template.cookbook_gems.keys).to include('test-kitchen')
    expect(template.cookbook_gems.keys).to include('kitchen-vagrant')
  end

  it 'should add the testkitchen rake tasks' do
    template = ChefGen::Flavor::TestKitchen.new(@recipe)
    template.generate
    expect(template.rake_tasks.keys).to include('testkitchen')
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'test_kitchen'
    ChefGen::Flavors.path
  end
end
