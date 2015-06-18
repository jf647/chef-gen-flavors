require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class ExampleTemplate < FlavorBase
      include ChefGen::Snippet::ExampleTemplate

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
RSpec.describe ChefGen::Snippet::ExampleTemplate do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  %w(templates templates/default).each do |dname|
    it "should create the directory #{dname}" do
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      template = ChefGen::Flavor::ExampleTemplate.new(@recipe)
      template.generate
    end
  end

  %w(templates/default/example.conf.erb).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:cookbook_file).with(%r{#{fname}$})
      template = ChefGen::Flavor::ExampleTemplate.new(@recipe)
      template.generate
    end
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'example_template'
    ChefGen::Flavors.path
  end
end
