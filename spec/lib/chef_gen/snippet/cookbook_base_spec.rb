require 'chef_gen/flavors'
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class CookbookBase < FlavorBase
      include ChefGen::Snippet::CookbookBase

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

RSpec.describe ChefGen::Snippet::CookbookBase do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  %w(Gemfile Rakefile Berksfile Guardfile README.md
     CHANGELOG.md metadata.rb).each do |fname|
    it "should add a template for #{fname}" do
      expect(@recipe).to receive(:template).with(/#{fname}$/)
      template = ChefGen::Flavor::CookbookBase.new(@recipe)
      template.generate
    end
  end

  it 'should copy snippet contents' do
    ChefGen::Flavors.disregard_plugin :baz
    ENV['CHEFGEN_FLAVOR'] = 'cookbook_base'
    ChefGen::Flavors.path
  end
end
